//
//  CardItem.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import Foundation
import RealmSwift

class CardItem: Object {
   
    @Persisted(primaryKey: true) var _id: Int
    @Persisted var frontWord: String
    @Persisted var backWord: String
    @Persisted var hasShown: Bool
    @Persisted var hasMemorized: Bool

}
