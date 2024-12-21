//
//  CardLearingStateRO.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 12/21/24.
//

import Foundation
import RealmSwift


///각 카드의 학습정보 Realm 객체
class CardLearingStateRO: Object {
    
    ///해당 한자 UUID
    @Persisted(primaryKey: true) var _id: UUID
    ///보여졌는지
    @Persisted var hasShown: Bool
    ///기억완료 표시된 카드인지
    @Persisted var hasMemorized: Bool
    ///즐겨찾기 표시된 카드인지
    @Persisted var isFavorite: Bool = false
    ///favorite를 true로 바꿀 때 생성되는 favoriteData이다. 별도의 hasShown, hasMemorized 정보가 만들어진다.
    @Persisted var favoriteItemRO: FavoriteItemRO?
    
}

