//
//  AppSetting.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 5/4/24.
//

import Foundation


class AppSetting {
    
    enum Keys: String {
        case cardDefaultSide
    }
    
    ///카드 전/후면 설정값
    static var cardDefaultSide: CardSideType {
        get {
            let intValue = UserDefaults.standard.integer(forKey: Keys.cardDefaultSide.rawValue)
            let value = CardSideType(rawValue: intValue) ?? .front
            shLog("cardDefaultSide value: \(String(describing: value))")
            return value
        }
        set {
            shLog("cardDefaultSide didSet: \(newValue)")
            UserDefaults.standard.setValue(newValue.rawValue, forKey: Keys.cardDefaultSide.rawValue)
        }
    }
    
}
