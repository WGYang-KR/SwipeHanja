//
//  ViewController.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit
import SwiftUI

class MainVC: UIViewController {
    
    var vm: MainVM!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVM()
        initTableView()
        titleLabel.text = "Swipe! 한자"
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    @IBAction func infoButtonTapped(_ sender: Any) {
        
        let view = SettingsView(resetProgressClosure: { [weak self] in
            guard let self else { return }
            self.vm.initCardPackIfNeeded(always: true)
            self.vm.prepareCardPackList()
            AlertHelper.notesInform(message: "모든 학습 진도가 초기화 되었습니다.")
        })
        let vc = UIHostingController(rootView: view)
        presentFull(vc, animated: true)
    }
    
    func initVM() {
        vm = MainVM()
        
//        vm.deleteAllDataFromRealm() //테스트용으로 항상 지우고 시작.
        vm.initCardPackIfNeeded()
        vm.prepareCardPackList()
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "\(CardPackItemCell.self)", bundle: nil), forCellReuseIdentifier: "\(CardPackItemCell.self)")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    

}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.cardPackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: "\(CardPackItemCell.self)", for: indexPath) as? CardPackItemCell
        else { return UITableViewCell() }
        let item = vm.cardPackList[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.remainCountLabel.text = String(item.remainCardCount)
        cell.totalCountLabel.text = String(item.totalCardCount)
        if item.remainCardCount == 0 {
            cell.remainCountLabel.textColor = .colorTeal02
            cell.remainCountLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
            cell.checkSealImageView.isHidden = false
            cell.chevronLeftImageView.isHidden = true
        } else if  item.remainCardCount < item.totalCardCount {
            cell.remainCountLabel.textColor = .colorTeal02
            cell.remainCountLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
            cell.checkSealImageView.isHidden = true
            cell.chevronLeftImageView.isHidden = false
        } else {
            cell.remainCountLabel.textColor = .colorTeal02
            cell.remainCountLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
            cell.checkSealImageView.isHidden = true
            cell.chevronLeftImageView.isHidden = false
        }

        
        return cell
        
    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = vm.cardPackList[indexPath.row]
        if item.learningStatus == .completed {
            AlertHelper.alertConfirm(baseVC: self, title: "학습이 완료된 챕터예요.\n학습을 다시 진행할까요?", message: "") {[weak self] in
                self?.vm.resetLearningStatus(at: indexPath.row)
                moveSwipeCardVC()
            }
        } else {
            moveSwipeCardVC()
        }
        
        func moveSwipeCardVC() {
            let vc = SwipeCardVC()
            vc.configure(cardPack: item)
            presentFull(vc, animated: true)
        }
        
    }
}
