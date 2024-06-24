//
//  WordListVC.swift
//  SwipeHanja
//
//  Created by WG-Yang on 5/16/24.
//

import UIKit

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
        self.sheetPresentationController?.prefersGrabberVisible = true
        initTableView()
    }
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "\(WordListItemCell.self)", bundle: nil), forCellReuseIdentifier: "\(WordListItemCell.self)")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
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
        
        return cell
    }
}

extension WordListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

