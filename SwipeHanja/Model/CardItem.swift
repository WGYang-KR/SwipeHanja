//
//  CardItem.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import Foundation

class CardItem: Codable {
   
    let id: Int
    let frontWord: String
    let backWord: String
    var hasShown: Bool
    var hasMemorized: Bool
    
    internal init(id: Int, frontWord: String, backWord: String, hasShown: Bool = false, hasMemorized: Bool = false) {
        self.id = id
        self.frontWord = frontWord
        self.backWord = backWord
        self.hasShown = hasShown
        self.hasMemorized = hasMemorized
    }
}
