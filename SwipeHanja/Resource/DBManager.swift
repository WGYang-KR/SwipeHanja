//
//  DBManager.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 12/22/24.
//

import Foundation
import RealmSwift

class DBManager {
    static let shared = DBManager()
    private init() { }

    var cardPacks: [CardPack] = []
    var totalCardItems: [CardItem] = []
    
    func initRealm() {
      
        ///objectID 이미그레이션(업데이트) 필요여부
        var isUpdateObjectIdNeeded = false
        
        let config = Realm.Configuration(schemaVersion: 2, migrationBlock: { migration, oldSchemaVersion in
            shLog("oldSchemaVersion: \(oldSchemaVersion)")
            isUpdateObjectIdNeeded = true
            self.loadCardsFromJson()
            if oldSchemaVersion < 2 {
                var totalCount = 0
                var successCount = 0
                var errorCount = 0
                
                //속성 확장 시작
                migration.enumerateObjects(ofType: CardItem.className()){ oldCardItem, newCardItem in
                    
                    if let oldCardItem,
                       let newCardItem,
                       let character: String = oldCardItem["frontWord"] as? String,
                       let newData = self.totalCardItems.first(where: { $0.frontWord == character }) {
                        newCardItem["radical"] = newData.radical
                        newCardItem["radicalMeaning"] = newData.radicalMeaning
                        newCardItem["strokeCount"] = newData.strokeCount
                        newCardItem["backDesc"] = newData.backDesc
                        successCount += 1
                    } else {
                        shLog("업데이트 오류: oldCardItem: \(String(describing: oldCardItem)), newCardItem: \(String(describing: newCardItem)), character: \(String(describing: oldCardItem?["frontWord"]) )")
                        errorCount += 1
                    }
                    totalCount += 1
                }
                
                shLog("속성확장 완료: totalCount: \(totalCount), successCount: \(successCount), errorCount:\(errorCount) ")
                
            }
        })
        
        
        // Use this configuration when opening realms
        Realm.Configuration.defaultConfiguration = config
        shLog("realm 위치: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")")
        
        //DB 속성 확장을 한 경우에 이미그레이션 진행
        if isUpdateObjectIdNeeded{
                updateObjectIDs()
        }
    }
    
    ///전체 카드 리스트를, CardPack  JSON에서 불러온다
    private func loadCardsFromJson() {
        do {
            cardPacks = try JSONSerialization.loadJSONFromFile(filename: "CardPacks_20241231", type: [CardPack].self)
            totalCardItems = cardPacks.reduce([CardItem](), { $0 + $1.cardList })
            shLog("전체 카드 데이터 JSON 로드 완료: \(totalCardItems.count)개")
        } catch(let error) {
            cardPacks = []
            totalCardItems = []
            shLog(error.localizedDescription)
        }
    }
    
    ///기존 데이터 objectID 지정해서 다시 삽입
    private func updateObjectIDs() {

        let realm = try! Realm()
        let oldObjects = realm.objects(CardItem.self) // 기존 객체 가져오기
        shLog("ObjectID 삽입 시작: \(oldObjects.count)")
        
        var totalCount = 0
        var successCount = 0
        var errorCount = 0
        
        //새 데이터 추가
        for cardItem in totalCardItems {
            totalCount += 1
            do {
                try realm.write {
                    if let oldObject = oldObjects.first(where: { $0.frontWord == cardItem.frontWord }) {
                        cardItem.hasShown = oldObject.hasShown
                        cardItem.hasMemorized = oldObject.hasMemorized
                        cardItem.isFavorite = oldObject.isFavorite
                        cardItem.favoriteData = oldObject.favoriteData
                        // 새 객체 추가
                        realm.add(cardItem)
                        successCount += 1
                    } else {
                        errorCount += 1
                    }
                }
            } catch(let error) {
                errorCount += 1
                shLog(error.localizedDescription)
            }
        }
        
        shLog("새 데이터 추가 완료: totalCount: \(totalCount), successCount: \(successCount), errorCount:\(errorCount) ")
        
        // 기존 데이터 삭제
        do {
            try realm.write {
                realm.delete(oldObjects)
            }
            shLog("기존 데이터 삭제완료")
        } catch {
            shLog(error.localizedDescription)
        }
    }
    
}
