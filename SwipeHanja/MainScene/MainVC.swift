//
//  ViewController.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {
    
//    let cardPack = CardPack(_id: ObjectId.generate(),
//                            index: 0,
//                            title: "상공회의소 9급",
//                            cardList: List<CardItem>)  [CardItem(_id: ObjectId.generate(), index: 1, level: 9, frontWord: "One", backWord: "일"),
//                                       CardItem(_id: ObjectId.generate(), index: 2, level: 9, frontWord: "Two", backWord: "이"),
//                                       CardItem(_id: ObjectId.generate(), index: 3, level: 9, frontWord: "Three", backWord: "삼"),
//                                       CardItem(_id: ObjectId.generate(), index: 4, level: 9, frontWord: "Four", backWord: "사"),
//                                       CardItem(_id: ObjectId.generate(), index: 5, level: 9, frontWord: "Five", backWord: "오")])
    var vm: MainVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vm = MainVM()
        
        vm.deleteAllDataFromRealm() //테스트용으로 항상 지우고 시작.
        
        if !vm.checkCardPackDBExists() {
            vm.deleteAllDataFromRealm()
            vm.initCardPackDBFromJson()
        }
        vm.prepareCardPackList()
    }


    @IBAction func didTapMoveBtn(_ sender: Any) {
        let vc = SwipeCardVC()
        guard let cardPack = vm.cardPackList.first else { return }
        vc.configure(cardPack: cardPack)
        presentFull(vc, animated: true)
    }
    
    
}

