//
//  SwipeCardVC.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit

class SwipeCardVC: UIViewController {

    var cardList: [CardItem] = [CardItem(id: 0, frontWord: "One", backWord: "일"),
                               CardItem(id: 1, frontWord: "Two", backWord: "이"),
                               CardItem(id: 2, frontWord: "Three", backWord: "삼"),
                               CardItem(id: 3, frontWord: "Four", backWord: "사"),
                               CardItem(id: 4, frontWord: "Five", backWord: "오")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.moveBackVC(animated: true)
    }
    
}
