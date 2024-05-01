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
    
    ///DB의 카드목록을 불러온다
    func prepareCardPackList() {
        do {
            let realm = try Realm()
            let results = realm.objects(CardPack.self)
            cardPackList =  Array(results)
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

