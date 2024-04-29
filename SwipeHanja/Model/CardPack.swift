//
//  CardPack.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/25/24.
//

import Foundation
import RealmSwift

class CardPack: Object {
    @Persisted(primaryKey: true) var _id: Int
    @Persisted var title: String //한자 9급
    @Persisted var cardList: List<CardItem> // = List<CardItem>()
}

