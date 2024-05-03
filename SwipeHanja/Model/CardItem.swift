//
//  CardItem.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import Foundation
import RealmSwift

final class CardItem: Object, Decodable {
   
   
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var index: Int
    @Persisted var level: Int
    @Persisted var frontWord: String
    @Persisted var backWord: String
    @Persisted var hasShown: Bool
    @Persisted var hasMemorized: Bool

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
        case frontWord
        case backWord
        case hasShown
        case hasMemorized
        
    }
    
    init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = ObjectId.generate()
        index = try container.decodeIfPresent(Int.self, forKey: .index) ?? 0
        level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 0
        frontWord = try container.decodeIfPresent(String.self, forKey: .frontWord) ?? ""
        backWord = try container.decodeIfPresent(String.self, forKey: .backWord) ?? ""
        hasShown = try container.decodeIfPresent(Bool.self, forKey: .hasShown) ?? false
        hasMemorized = try container.decodeIfPresent(Bool.self, forKey: .hasMemorized) ?? false
    
    }
    
    //MARK: -
    func setObserver() {
        // Realm에 추가되었을 때의 변화를 감지하는 코드
        notificationToken = self.observe { (change) in
            switch change {
            case .change:
                // 변화가 감지되면 Realm에 자동으로 저장
                shLog("CarItem 변경감지 됨")
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
    }
    
    func removeObserver() {
        // 옵저버가 더 이상 필요하지 않을 때 메모리 해제
        notificationToken?.invalidate()
    }
    
    //MARK: -
    //샘플데이터용
    internal init(_id: ObjectId, index: Int, level: Int, frontWord: String, backWord: String, hasShown: Bool, hasMemorized: Bool) {
        super.init()
        self._id = _id
        self.index = index
        self.level = level
        self.frontWord = frontWord
        self.backWord = backWord
        self.hasShown = hasShown
        self.hasMemorized = hasMemorized
    }
}
