//
//  SwipeCardVC.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit

let sampleData: [CardItem] = [CardItem(id: 0, frontWord: "One", backWord: "일"),
                              CardItem(id: 1, frontWord: "Two", backWord: "이"),
                              CardItem(id: 2, frontWord: "Three", backWord: "삼"),
                              CardItem(id: 3, frontWord: "Four", backWord: "사"),
                              CardItem(id: 4, frontWord: "Five", backWord: "오")]

class SwipeCardVC: UIViewController {

    
    var dataSource: [CardItem] = sampleData
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    // MARK: IBActions

    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    @IBAction func topBackBtnTapped(_ sender: Any) {
        self.moveBackVC(animated: true)
    }
    
}

// MARK: KolodaViewDelegate

extension SwipeCardVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        let position = kolodaView.currentCardIndex
        let increasingNumber = sampleData.count
        dataSource += sampleData

        kolodaView.insertCardAtIndexRange(position..<position + increasingNumber, animated: true)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }

}

// MARK: KolodaViewDataSource

extension SwipeCardVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return  CardItemView(text: dataSource[index].frontWord)
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

