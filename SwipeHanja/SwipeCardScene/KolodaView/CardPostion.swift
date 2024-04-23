//
//  CardPostion.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/23/24.
//

import Foundation

enum CardPosition {
    case front, back
    
    var reversed: Self {
        return self == .front ? .back : .front
    }
}
