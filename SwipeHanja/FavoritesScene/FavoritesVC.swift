//
//  FavoritesVC.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 6/18/24.
//

import UIKit
import Combine

class FavoritesVC: UIViewController {

    var cancellables = Set<AnyCancellable>()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let vm = FavoritesVM()
    
    enum SectionType {
        case startLearning
        case items
    }
    var sectionTypes:[SectionType] = [.startLearning, .items]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchFavoriteItem()
        tableView.reloadData()
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "\(FavoritesStartLearningCell.self)", bundle: nil), forCellReuseIdentifier: "\(FavoritesStartLearningCell.self)")
        tableView.register(UINib(nibName: "\(FavoritesItemCell.self)", bundle: nil), forCellReuseIdentifier: "\(FavoritesItemCell.self)")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.contentInset = UIEdgeInsets(top: -20.0, left: 0, bottom: 0, right: 0)
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
            return vm.favoriteItems.value.count
        }
 
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
        switch sectionTypes[titleForHeaderInSection] {
        case .startLearning:
            return nil
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
            cell.totalCountLabel.text = "\(vm.totalCardCount)"
            cell.remainCountLabel.text = "\(vm.remainCardCount)"
            return cell
        case .items:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "\(FavoritesItemCell.self)", for: indexPath) as? FavoritesItemCell
            else { return UITableViewCell() }
            let item = vm.favoriteItems.value[indexPath.row]
            cell.configure(firstText: item.cardItem.frontWord,
                           secondText: item.cardItem.backWord,
                           isFavorite: item.isFavorite)
            cell.isFavorite.dropFirst().sink { [weak self] newValue in
                //DB 값 갱신
                item.updateFavorite(newValue)
                
                //단어 총갯수 변경
                guard let startLearingIndex = self?.sectionTypes.firstIndex(of: .startLearning) else { return }
                self?.tableView.reloadSections( IndexSet(integer: startLearingIndex), with: .none)
                
            }.store(in: &cell.reusableCancellables)
            return cell
        }
        
    }
    
    
}

extension FavoritesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
