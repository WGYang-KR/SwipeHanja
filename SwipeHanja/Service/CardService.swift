//
//  CardService.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 12/21/24.
//

import Foundation
import RealmSwift


class CardService {
    static let shared: CardService = CardService()
    private init() { }
    
    ///분류 안된 전체 카드 목록
    var cardItems: [CardItemModel] = []
    ///카드묶음 목록
    var cardPacks: [CardPackModel] = []
    ///단어장 카드 목록
    var favoriteItems: [FavoriteItemModel] = []
  
    
    
    //1. 카드 데이터 로드(한번만 실행)
    //CardPack 파일별로 카드 목록([HanjaModel]) 로드
    //DB에 저장된 학습정보(CardLearningStateRO)와 합성하여 CardPackModel init
    
    //2. 단어장 카드 목록(화면 진입시마다 실행)
    //DB에 저장된 단어장 카드목록(FavoriteItemRO) 과 1.에서 로드된 카드목록과 합성하여 favoriteItems init
    
    //3.
}
