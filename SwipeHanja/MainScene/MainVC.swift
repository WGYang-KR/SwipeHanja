//
//  ViewController.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit


class MainVC: UIViewController {
    
    let cardPack = CardPack(id: 0,
                            title: "상공회의소 9급",
                            cardList: [CardItem(id: 0, frontWord: "One", backWord: "일"),
                                       CardItem(id: 1, frontWord: "Two", backWord: "이"),
                                       CardItem(id: 2, frontWord: "Three", backWord: "삼"),
                                       CardItem(id: 3, frontWord: "Four", backWord: "사"),
                                       CardItem(id: 4, frontWord: "Five", backWord: "오")])


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapMoveBtn(_ sender: Any) {
        let vc = SwipeCardVC()
        vc.configure(cardPack: cardPack)
        presentFull(vc, animated: true)
    }
    
}

