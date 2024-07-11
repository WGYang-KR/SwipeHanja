//
//  WordListVC.swift
//  SwipeHanja
//
//  Created by WG-Yang on 5/16/24.
//

import UIKit
import Combine

class WordListVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var cardList: [CardItem] = []
    
    func configure(cardList: [CardItem] ) {
        self.cardList = cardList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .colorGrey04
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        initTableView()
    }
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "\(WordListItemCell.self)", bundle: nil), forCellReuseIdentifier: "\(WordListItemCell.self)")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func searchBtnTapped(at index: Int) {
        let item = cardList[index]
        let vc = SearchWebVC()
        vc.configuration(searchText: item.frontWord)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.moveBackVC(animated: true)
    }
}

extension WordListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "\(WordListItemCell.self)", for: indexPath) as! WordListItemCell
        let item = cardList[indexPath.row]
        cell.configure(index: indexPath.row + 1, firstText: item.frontWord, secondText: item.backWord, checked: item.hasMemorized)
        cell.selectBtnTappedSubject.sink { [weak self] in
            self?.searchBtnTapped(at: indexPath.row)
        }.store(in: &cell.cancellables)
        
        return cell
    }
    
  
    
}

extension WordListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

