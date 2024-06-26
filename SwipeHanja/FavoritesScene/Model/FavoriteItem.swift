//
//  FavoriteItem.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 6/26/24.
//

import Foundation
import RealmSwift

class FavoriteItem {
    let cardItem: CardItem
    var favoriteData: FavoriteData?
    var isFavorite: Bool
    
    init(cardItem: CardItem, favoriteData: FavoriteData?, isFavorite: Bool) {
        self.cardItem = cardItem
        self.favoriteData = favoriteData
        self.isFavorite = isFavorite
    }
}
