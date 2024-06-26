//
//  CardItem.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import Foundation
import RealmSwift

final class CardItem: Object, Decodable {
   
   
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var index: Int
    @Persisted var level: Int
    @Persisted var frontWord: String
    @Persisted var backWord: String
    @Persisted var hasShown: Bool
    @Persisted var hasMemorized: Bool
    @Persisted var isFavorite: Bool = false
    ///favorite를 true로 바꿀 때 생성되는 favoriteData이다. 별도의 hasShown, hasMemorized 정보가 만들어진다.
    @Persisted var favoriteData: FavoriteData?

    override init() {
        super.init()
    }
    
    deinit {
    }
    
    //MARK: - Decodable
    enum CodingKeys: String, CodingKey {
        case index
        case level
        case frontWord
        case backWord
        case hasShown
        case hasMemorized
        case isFavorite
        
    }
    
    init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = ObjectId.generate()
        index = try container.decodeIfPresent(Int.self, forKey: .index) ?? 0
        level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 0
        frontWord = try container.decodeIfPresent(String.self, forKey: .frontWord) ?? ""
        backWord = try container.decodeIfPresent(String.self, forKey: .backWord) ?? ""
        hasShown = try container.decodeIfPresent(Bool.self, forKey: .hasShown) ?? false
        hasMemorized = try container.decodeIfPresent(Bool.self, forKey: .hasMemorized) ?? false
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
    
    //MARK: -
    //샘플데이터용
    internal init(_id: ObjectId, index: Int, level: Int, frontWord: String, backWord: String, hasShown: Bool, hasMemorized: Bool) {
        super.init()
        self._id = _id
        self.index = index
        self.level = level
        self.frontWord = frontWord
        self.backWord = backWord
        self.hasShown = hasShown
        self.hasMemorized = hasMemorized
        self.isFavorite = false
    }
}
