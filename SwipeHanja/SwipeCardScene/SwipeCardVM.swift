//
//  SwipeCardService.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/25/24.
//

import Foundation
import Combine

class SwipeCardVM {
    
    ///카드팩
    let cardPack: CardPack
    
    ///현재 학습중인 카드리스트
    let cardList = CurrentValueSubject<[CardItem],Never>([])
    ///학습중인 전체 카드 개수
    let totalCardCount = CurrentValueSubject<Int,Never>(0)
    ///미학습 카드 개수
    let remainCardCount = CurrentValueSubject<Int,Never>(0)
    ///암기 카드 카운트
    let yesCardCount = CurrentValueSubject<Int,Never>(0)
    ///미암기 카드 카운트
    let noCardCount = CurrentValueSubject<Int,Never>(0)
    
    ///카드팩으로 서비스를 init한다.
    init(cardPack: CardPack) {
        self.cardPack = cardPack
    }
    
    ///미학습 또는 미암기 카드만 추출하여 카드리스트를 준비한다.
    func prepareCardList() {
        cardList.send(cardPack.cardList.filter { !$0.hasMemorized || !$0.hasShown } )
        totalCardCount.send(cardList.value.count)
        remainCardCount.send(0)
        yesCardCount.send(0)
        noCardCount.send(0)
    }
    
    ///모든 카드의 학습상태  정보를 삭제하고, 카드리스트를 다시 준비한다.
    func deleteStudyStatus() {
        cardPack.cardList.forEach {
            if $0.hasShown { $0.hasShown = false }
            if $0.hasMemorized { $0.hasMemorized = false }
        }
        
        prepareCardList()
        
    }
    
    ///특정 카드의 학습상태를 되돌린다.
    func revertCardStatus(at index: Int) {
        guard index < cardList.value.count else { shLog("오류: 오버레인지"); return  }
        let item = cardList.value[index]
        
        item.hasMemorized ? (yesCardCount.send(yesCardCount.value - 1)) : (noCardCount.send(noCardCount.value - 1))
        remainCardCount.send(remainCardCount.value + 1)
        
        item.hasShown = false
        item.hasMemorized = false
        
    }
    
    ///카드 학습표시 및 암기 유무를  체크한다.
    func markMemorized(at index: Int, _ isMemorized: Bool) {
        guard index < cardList.value.count else { shLog("오류: 오버레인지"); return  }
        let item = cardList.value[index]
        
        isMemorized ? (yesCardCount.send(yesCardCount.value + 1)) : (noCardCount.send(noCardCount.value + 1))
        remainCardCount.send(remainCardCount.value - 1)
        
        item.hasShown = true
        item.hasMemorized = isMemorized
   
    }
    
    
}
