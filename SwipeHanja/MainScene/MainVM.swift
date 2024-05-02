//
//  MainVM.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 5/1/24.
//

import Foundation
import RealmSwift

class MainVM {
    
    ///카드팩
    var cardPackList: [CardPack] = []

    ///DB를 초기화한다.
    func initCardPackDBFromJson() {
        do {
            let cardPackList = try JSONSerialization.loadJSONFromFile(filename: "CardData", type: [CardPack].self)
            let realm = try Realm()
            try realm.write {
                realm.add(cardPackList)
            }
        } catch(let error) {
            shLog(error.localizedDescription)
        }
    }
    
    func checkCardPackDBExists() -> Bool {
        do {
            // Realm 설정
            let realm = try Realm()
            
            // YourObject 클래스에 해당하는 객체들을 쿼리하여 결과 확인
            let objects = realm.objects(CardPack.self)
            if objects.count > 0 {
                print("Objects of type YourObject found in Realm")
                return true
            } else {
                print("No objects of type YourObject found in Realm")
                return false
            }
            
        } catch(let error) {
            shLog(error.localizedDescription)
            return false
        }
    }
    
    ///DB의 카드목록을 불러온다
    func prepareCardPackList() {
        do {
            let realm = try Realm()
            let results = realm.objects(CardPack.self)
            cardPackList =  Array(results)
            for pack in cardPackList {
                pack.setObserver()
            }
        } catch {
            shLog("Error retrieving data from Realm: \(error)")
            cardPackList = []
        }
    }
    
    func deleteAllDataFromRealm() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            shLog("Error deleting data from Realm: \(error)")
        }
    }
    
}

