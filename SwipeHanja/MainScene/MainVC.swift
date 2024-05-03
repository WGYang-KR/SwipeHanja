//
//  ViewController.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit
import RealmSwift

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

    @IBAction func didTapInfoBtn(_ sender: Any) {
        
    }
    
    func initVM() {
        vm = MainVM()
        
        vm.deleteAllDataFromRealm() //테스트용으로 항상 지우고 시작.
        
        if !vm.checkCardPackDBExists() {
            vm.deleteAllDataFromRealm()
            vm.initCardPackDBFromJson()
        }
        
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
        
        return cell
        
    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let vc = SwipeCardVC()
        let item = vm.cardPackList[indexPath.row]
        vc.configure(cardPack: item)
        presentFull(vc, animated: true)
    }
}
