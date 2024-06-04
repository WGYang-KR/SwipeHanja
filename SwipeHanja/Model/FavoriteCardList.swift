//
//  FavoriteCardList.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 6/4/24.
//

import Foundation
import RealmSwift

final class FavoriteCardList: Object{
   
    @Persisted var cardList: List<CardItem> // = List<CardItem>()
    
}

extension FavoriteCardList {
    ///총 카드수
    var totalCardCount: Int {
        return cardList.count
    }
    
}
