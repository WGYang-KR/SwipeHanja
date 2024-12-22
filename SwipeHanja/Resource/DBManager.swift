//
//  DBManager.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 12/22/24.
//

import foundation
import RealmSwift

class DBManager {
    static let shared = DBManager()
    private init() { }

    var cardPacks: [CardPack] = []
    var totalCardItems: [CardItem] = []
    
    func initRealm() {
        
        // Realm의 기본 구성 > 현재버전 확인
        let currentSchemaVersion = Realm.Configuration.defaultConfiguration.schemaVersion
        shLog("현재 스키마 버전: \(currentSchemaVersion)")
        
        // 최신 DB버전은 2임
        var config = Realm.Configuration(schemaVersion: 2)
        if currentSchemaVersion < 2 { //버전이 2보다 낮으면 DB 속성 확장 필요
            
            loadCardsFromJson()
            
            config = Realm.Configuration(schemaVersion: 2, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    ///속성 확장
                    migration.enumerateObjects(ofType: CardItem.className()){ oldCardItem, newCardItem in
                        if let oldCardItem,
                           let newCardItem,
                           let character: String = oldCardItem["frontWord"] as? String,
                           let newData = self.cardPackList.first(where: { $0.frontWord == character }) {
                            newCardItem["radical"] = newData.radical
                            newCardItem["radicalMeaning"] = newData.radicalMeaning
                            newCardItem["strokeCount"] = newData.strokeCount
                            newCardItem["backDesc"] = newData.backDesc
                            
                        } else {
                            shLog("업데이트 오류: oldCardItem: \(String(describing: oldCardItem)), newCardItem: \(String(describing: newCardItem)), character: \(String(describing: oldCardItem?["frontWord"]) )")
                        }
                        
                    }
                }
            })
        }
        
        // Use this configuration when opening realms
        Realm.Configuration.defaultConfiguration = config
        shLog("realm 위치: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")")
        
        //DB 속성 확장을 한 경우에 이미그레이션 진행
        if currentSchemaVersion < 2 {
            migrateObjects()
        }
    }
    
    ///전체 카드 리스트를, CardPack  JSON에서 불러온다
    private func loadCardsFromJson() {
        do {
            cardPacks = try JSONSerialization.loadJSONFromFile(filename: "CardPacks", type: [CardPack].self)
            totalCardItems = cardPacks.reduce([CardItem](), { $0 + $1.cardList })
            shLog("전체 카드 데이터 JSON 로드 완료: \(totalCardItems.count)개")
        } catch(let error) {
            cardPacks = []
            totalCardItems = []
            shLog(error.localizedDescription)
        }
    }
    
    ///기존 데이터 objectID 지정해서 다시 삽입
    private func migrateObjects() {
        
        let oldObjects = realm.objects(CardItem.self) // 기존 객체 가져오기
        
        do  {
            try realm.write {
                var count = 0
                for cardItem in totalCardItems {
                    if let oldObject = oldObjects.first(where: { $0.frontWord == cardItem.frontWord }) {
                        cardItem.hasShown = oldObject.hasShown
                        cardItem.hasMemorized = oldObject.hasMemorized
                        cardItem.isFavorite = oldObject.isFavorite
                        cardITem.favoriteData = oldObject.favoriteData
                        // 새 객체 추가
                        realm.add(cardItem)
                        count += 1
                    }
                }
                // 기존 객체 삭제
                realm.delete(oldObjects)
                
                shLog("한자 이미그레이션 완로: \(count) 개")
                
            }
        } catch {
            catch(let error) {
                shLog(error.localizedDescription)
            }
        }
    }
}
