//
//  CardPack.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/25/24.
//

import Foundation
import RealmSwift

final class CardPack: Object, Codable{
   
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var index: Int
    @Persisted var level: Int
    @Persisted var title: String //한자 9급
    @Persisted var cardList: List<CardItem> // = List<CardItem>()
    
    
    //샘플데이터용
    internal init(_id: ObjectId, index: Int, level: Int, title: String, cardList: List<CardItem>) {
        super.init()
        self._id = _id
        self.index = index
        self.level = level
        self.title = title
        self.cardList = cardList
    }
    
    //Decodable
    init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = ObjectId.generate()
        index = try container.decodeIfPresent(Int.self, forKey: .index) ?? 0
        level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        let cardArray = try container.decodeIfPresent([CardItem].self, forKey: .cardList) ?? []
        var newCardList = List<CardItem>()
        for item in cardArray {
            newCardList.append(item)
        }
    
    }
}

extension CardPack {
    ///총 카드수
    var totalCardCount: Int {
        return cardList.count
    }
    
    ///암기 잔여 카드수
    var remainCardCount: Int {
        return cardList.filter{!$0.hasMemorized}.count
    }
}
