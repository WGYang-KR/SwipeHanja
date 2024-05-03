//
//  CardPack.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/25/24.
//

import Foundation
import RealmSwift

final class CardPack: Object, Decodable{
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var index: Int
    @Persisted var level: Int
    @Persisted var title: String //한자 9급
    @Persisted var cardList: List<CardItem> // = List<CardItem>()
    
    // Realm에 자동으로 업데이트되도록 변수를 관찰
    private var notificationToken: NotificationToken?
    
    override init() {
        super.init()
    }
    
    deinit {
        removeObserver()
    }
    
    
    //MARK: - Decodable
    enum CodingKeys: String, CodingKey {
        case index
        case level
        case title
        case cardList
    }
    
    init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = ObjectId.generate()
        index = try container.decodeIfPresent(Int.self, forKey: .index) ?? 0
        level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        let cardArray = try container.decodeIfPresent([CardItem].self, forKey: .cardList) ?? []
        let newCardList = List<CardItem>()
        for item in cardArray {
            newCardList.append(item)
        }
        cardList = newCardList
        
        notificationToken = nil
        
    }
    
    //MARK: -
    func setObserver() {
        // Realm에 추가되었을 때의 변화를 감지하는 코드
        notificationToken = self.observe { (change) in
            switch change {
            case .change:
                // 변화가 감지되면 Realm에 자동으로 저장
                shLog("CardPack 변경됨")
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(self, update: .modified)
                    }
                } catch {
                    shLog("An error occurred: \(error)")
                }
            case .error(let error):
                // 에러 처리
                shLog("An error occurred: \(error)")
            case .deleted:
                // 객체가 삭제되면 추가 작업 수행
                shLog("Object deleted")
            }
        }
        
        //CardItem들에 대한 옵저버 설정
        for cardItem in cardList {
            cardItem.setObserver()
        }
        
    }
    
    func removeObserver() {
        // 옵저버가 더 이상 필요하지 않을 때 메모리 해제
        notificationToken?.invalidate()
    }
    
    //MARK: - 
    //샘플데이터용
    internal init(_id: ObjectId, index: Int, level: Int, title: String, cardList: List<CardItem>) {
        super.init()
        self._id = _id
        self.index = index
        self.level = level
        self.title = title
        self.cardList = cardList
        
    }
}

extension CardPack {
    ///총 카드수
    var totalCardCount: Int {
        return cardList.count
    }
    
    ///암기 잔여 카드수
    var remainCardCount: Int {
        return cardList.filter{!$0.hasMemorized}.count
    }
}
