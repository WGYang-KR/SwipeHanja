//
//  FavoritesSwipeVC.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 7/5/24.
//

import UIKit
import Combine

class FavoritesSwipeVC: UIViewController {

    var vm: FavoritesSwipeVM = FavoritesSwipeVM()
    var dataSource: [FavoriteItem] { vm.cardList.value }
    
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLeftLabel: UILabel!
    @IBOutlet weak var countRightLabel: UILabel!
    @IBOutlet weak var remainCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!

    var cardDefaultSide: CardSideType = .front
    var cardFontType: FontType = .system
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        initCardDefaultSide()
       
        bindVM()
        vm.fetchFavoriteItem()
        vm.prepareCardList()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        

        func initCardDefaultSide() {
            cardDefaultSide = AppSetting.cardDefaultSide
        }
        
    }
    
    // MARK: IBActions
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
        setCardDefaultSide(cardDefaultSide.reversed)
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
    
    ///카드 전후면 설정을 업데이트한다
    func setCardDefaultSide(_ side: CardSideType) {
        cardDefaultSide = side
        AppSetting.cardDefaultSide = side
        
        let cardSideDesc = cardDefaultSide == .front ? "'한자'로" : "'뜻'으로"
        AlertHelper.notesInform(message: "기본 카드 방향이 \(cardSideDesc) 변경됨")
        
        kolodaView.reconfigureCards()
        
    }
}


// MARK: KolodaViewDelegate

extension FavoritesSwipeVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        vm.prepareCardList()
        kolodaView.resetCurrentCardIndex()
    
        if dataSource.count == 0 { // 학습완료시
            vm.deleteStudyStatus()
            let vc = SwipeCardCompletionPopUpVC()
            vc.configure(screenType: .fromFavoritesStudy){ [weak self] in
                self?.moveBackVC(animated: true)
            }
            presentOverFull(vc, animated: false)
        }
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

extension FavoritesSwipeVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let item = dataSource[index]
        let cardItemView = CardItemView()
       
        var font: UIFont?
        switch cardFontType {
        case .system:
            font = .systemFont(ofSize: 56)
        case .KanjiStrokeOrders:
            font = .init(name: "KanjiStrokeOrders", size: 80)
        }
        cardItemView.configure(index: index,
                               frontContent: .init(text: item.cardItem.frontWord,
                                                   font: font),
                               backContent: .init(text: item.cardItem.backWord,
                                                  font: nil),
                               isFavorite: item.isFavorite,
                               delegate: self,
                               cardSideType: cardDefaultSide)
        
        return cardItemView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("\(SHOverlayView.self)", owner: self, options: nil)?[0] as? SHOverlayView
    }
}

//MARK: CardItemComponentViewDelegate

extension FavoritesSwipeVC: CardItemViewDelegate {

    func cardItemViewFavoriteButtonToggled(at index: Int, _ marked: Bool) {
        shLog("Favorite Toggled: \(marked)")
        vm.markFavorite(at: index, marked)
    }
    
    func cardItemViewSerachButtonTapped(at index: Int) {
        let item = dataSource[index]
        let vc = SearchWebVC()
        vc.configuration(searchText: item.cardItem.frontWord)
        presentOverFull(vc, animated: true)
    }
    
    
}
