//
//  FavoritesVC.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 6/18/24.
//

import UIKit

class FavoritesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    enum SectionType {
        case startLearning
        case items
    }
    var sectionTypes:[SectionType] = [.startLearning, .items]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()

    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "\(FavoritesStartLearningCell.self)", bundle: nil), forCellReuseIdentifier: "\(FavoritesStartLearningCell.self)")
        tableView.register(UINib(nibName: "\(FavoritesItemCell.self)", bundle: nil), forCellReuseIdentifier: "\(FavoritesItemCell.self)")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
    }
}

extension FavoritesVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionTypes[section] {
        case .startLearning:
            return 1
        case .items:
            return 3
        }
 
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
        switch sectionTypes[titleForHeaderInSection] {
        case .startLearning:
            return ""
        case .items:
            return "저장된 단어"
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sectionTypes[indexPath.section] {
        case .startLearning:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "\(FavoritesStartLearningCell.self)", for: indexPath) as? FavoritesStartLearningCell
            else { return UITableViewCell() }
            
            return cell
        case .items:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "\(FavoritesItemCell.self)", for: indexPath) as? FavoritesItemCell
            else { return UITableViewCell() }
//            let item = vm.cardPackList[indexPath.row]
            return cell
        }
        
    }
    
    
}

extension FavoritesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
