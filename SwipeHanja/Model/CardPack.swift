//
//  CardPack.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/25/24.
//

import Foundation

class CardPack: Codable {
    
    let id: Int
    let title: String
    let cardList: [CardItem]
    
    init(id: Int, title: String, cardList: [CardItem]) {
        self.id = id
        self.title = title
        self.cardList = cardList
    }
}

