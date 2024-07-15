//
//  SwipeCardVC.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit
import Combine
import StoreKit

class SwipeCardVC: UIViewController {

    var vm: SwipeCardVM!
    var dataSource: [CardItem] { vm.cardList.value }
    
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLeftLabel: UILabel!
    @IBOutlet weak var countRightLabel: UILabel!
    @IBOutlet weak var remainCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!

    var cardDefaultSide: CardSideType = .front
    var cardFontType: FontType = .system
    
    func configure(cardPack: CardPack) {
        self.vm = SwipeCardVM(cardPack: cardPack) 
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        initCardDefaultSide()
       
        bindVM()
        vm.prepareCardList(shuffle: false)
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        titleLabel.text = vm.cardPack.title
    
        func initCardDefaultSide() {
            cardDefaultSide = AppSetting.cardDefaultSide
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    @IBAction func resetButtonTapped(_ sender: Any) {

        AlertHelper.alertConfirm(baseVC: self,
                                 title: "학습기록을 초기화할까요?",
                                 message: "" ) { [weak self] in
            guard let self else { return }
            vm.deleteStudyStatus()
            vm.prepareCardList(shuffle: false)
            kolodaView.resetCurrentCardIndex()
            AlertHelper.notesInform(message: "학습기록이 초기화되었습니다.")
        }
  
    }
    
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        AlertHelper.alertConfirm(baseVC: self,
                                 title: "카드 순서를 무작위로 섞을까요?",
                                 message: "" ) { [weak self] in
            guard let self else { return }
            vm.prepareCardList(shuffle: true)
            kolodaView.resetCurrentCardIndex()
        }
        
    }
    
    
    @IBAction func topBackBtnTapped(_ sender: Any) {
        self.moveBackVC(animated: true)
    }
    
    @IBAction func toggleCardDefaultSideBtnTapped(_ sender: Any) {
        setCardDefaultSide(cardDefaultSide.reversed)
    }
    
    
    @IBAction func listButtonTapped(_ sender: Any) {
        let vc = WordListVC()
        vc.configure(cardList: vm.cardPack.cardList.map({$0}), swipeCardVC: self)
        navigationController?.pushViewController(vc, animated: true)
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
        
        Publishers.CombineLatest(vm.totalCardCount, vm.remainCardCount)
            .sink { [weak self] total, remain in
                let done = total - remain
                let progressRate: Float = total > 0 ? Float(done) / Float(total) : 1.0
                shLog("Progress: \(progressRate)")
                self?.updateProgressView(progressRate)
            }
            .store(in: &cancellables)
        
    }
    
    //MARK: -
    ///카드 전후면 설정을 업데이트한다
    func setCardDefaultSide(_ side: CardSideType) {
        cardDefaultSide = side
        AppSetting.cardDefaultSide = side
        
        let cardSideDesc = cardDefaultSide == .front ? "'한자'로" : "'뜻'으로"
        AlertHelper.notesInform(message: "기본 카드 방향이 \(cardSideDesc) 변경됨")
        
        kolodaView.reconfigureCards()
        
    }
    
    ///진행상태바를 업데이트 한다.
    func updateProgressView(_ rate: Float) {
        progressView.progress = rate <= 1.0 ? rate : 1.0
    }
    
    func favoriteDataUpdated() {
        kolodaView.reconfigureCards()
    }

}

// MARK: KolodaViewDelegate

extension SwipeCardVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        vm.prepareCardList(shuffle: false)
        kolodaView.resetCurrentCardIndex()
    
        if dataSource.count == 0 { // 학습완료시
            let vc = SwipeCardCompletionPopUpVC()
            vc.configure { [weak self] in
                self?.moveBackVC(animated: true) {
                    
                    //리뷰 요청을 한다.
                    if !AppStatus.hasRequestedReview {
                        AppStatus.hasRequestedReview = true
                        SKStoreReviewController.requestReview()
                    }
                }
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

extension SwipeCardVC: KolodaViewDataSource {
    
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
                               frontContent: .init(text: item.frontWord,
                                                   font: font),
                               backContent: .init(text: item.backWord,
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

extension SwipeCardVC: CardItemViewDelegate {

    
    func cardItemViewFavoriteButtonToggled(at index: Int, _ marked: Bool) {
        shLog("Favorite Toggled: \(marked)")
        vm.markFavorite(at: index, marked)
    }
    
    func cardItemViewSerachButtonTapped(at index: Int) {
        let item = dataSource[index]
        let vc = SearchWebVC()
        vc.configuration(searchText: item.frontWord)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
