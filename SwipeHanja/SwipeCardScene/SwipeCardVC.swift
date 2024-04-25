//
//  SwipeCardVC.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit

class SwipeCardVC: UIViewController {

    var vm: SwipeCardVM!
    var dataSource: [CardItem] { vm.cardList }
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLeftLabel: UILabel!
    @IBOutlet weak var countRightLabel: UILabel!
    @IBOutlet weak var countMiddleLabel: UILabel!
    
    func configure(cardPack: CardPack) {
        self.vm = SwipeCardVM(cardPack: cardPack)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.prepareCardList()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        
    }
    // MARK: IBActions

    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        if (kolodaView?.currentCardIndex ?? 0)  > 0 {
            vm.revertCardStatus(at: kolodaView.currentCardIndex)
        }
        kolodaView?.revertAction()
            
    }
    
    @IBAction func topBackBtnTapped(_ sender: Any) {
        self.moveBackVC(animated: true)
    }
    
}

// MARK: KolodaViewDelegate

extension SwipeCardVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        let position = kolodaView.currentCardIndex
//        let increasingNumber = sampleData.count
//        dataSource += sampleData
//
//        kolodaView.insertCardAtIndexRange(position..<position + increasingNumber, animated: true)
        vm.prepareCardList()
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return 0.5
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        vm.markMemorized(at: index, direction == .right ? true : false)
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
    
    func koloda(_ koloda: KolodaView, backViewForCardAt index: Int) -> UIView {
        return  CardItemView(text: dataSource[index].backWord)
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

