//
//  FavoriteItemRO.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 6/25/24.
//

import Foundation
import RealmSwift

//CardItem을 품고 별도의 hasShown hasMemorized 정보를 추가로 가진 객체
class FavoriteItemRO: Object {

    ///현 아이템을 참조하고 있는 부모 CardItem
    @Persisted(originProperty: "favoriteItemRO") var parentCardItem: LinkingObjects<CardLearingStateRO>
    ///해당한자 UUID
    @Persisted(primaryKey: true) var _id: UUID
    ///추가된 날짜
    @Persisted var timestamp = Date()
    @Persisted var hasShown: Bool = false
    @Persisted var hasMemorized: Bool = false
    
}
