//
//  SwipeCardVC.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit
import Combine

class SwipeCardVC: UIViewController {

    var vm: SwipeCardVM!
    var dataSource: [CardItem] { vm.cardList.value }
    
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLeftLabel: UILabel!
    @IBOutlet weak var countRightLabel: UILabel!
    @IBOutlet weak var remainCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!

    var cardDefaultSide: CardSideType = .front
    
    func configure(cardPack: CardPack) {
        self.vm = SwipeCardVM(cardPack: cardPack) 
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardDefaultSide = AppSetting.cardDefaultSide
        kolodaView.cardDefaultSide = cardDefaultSide
        
        bindVM()
        vm.prepareCardList()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        titleLabel.text = vm.cardPack.title
    
        
    }
    
    // MARK: IBActions

    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        if let kolodaView, kolodaView.canRevert() {
            vm.revertCardStatus(at: kolodaView.currentCardIndex - 1)
            kolodaView.revertAction()
        } else {
            shLog("Revert 무시됨")
        }
        
        
    }
    
    @IBAction func topBackBtnTapped(_ sender: Any) {
        self.moveBackVC(animated: true)
    }
    
    @IBAction func toggleCardDefaultSideBtnTapped(_ sender: Any) {
        cardDefaultSide = cardDefaultSide.reversed
        AppSetting.cardDefaultSide = cardDefaultSide
        kolodaView.cardDefaultSide = cardDefaultSide
    }
    
    
    @IBAction func listButtonTapped(_ sender: Any) {
    }
    
   
    
    //MARK: Bind ViewModel
    func bindVM() {

        vm.noCardCount.sink { [weak self] newValue in
            self?.countLeftLabel.text = String(newValue)
        }.store(in: &cancellables)
        
        vm.yesCardCount.sink { [weak self] newValue in
            self?.countRightLabel.text = String(newValue)
        }.store(in: &cancellables)
        
        vm.remainCardCount.combineLatest(vm.totalCardCount).sink { [weak self] remain, total in
            self?.remainCountLabel.text = String(remain)
            self?.totalCountLabel.text = String(total)
        }.store(in: &cancellables)
        
    }
    
    
}

// MARK: KolodaViewDelegate

extension SwipeCardVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
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

