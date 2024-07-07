//
//  FavoritesItemCell.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 6/24/24.
//

import UIKit
import Combine
class FavoritesItemCell: UITableViewCell {

    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    let linedStarImage: UIImage? = .init(systemName: "star")
    let filledStarImage: UIImage? = .init(systemName: "star.fill")
    
    ///변경시에 UI도 같이 갱신된다.
    let isFavorite = CurrentValueSubject<Bool,Never>(false)
    var cancellables = Set<AnyCancellable>()
    var reusableCancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        isFavorite.sink { [weak self] value in
            //favorite 여부 바뀌먄 UI 갱신
            self?.setFavoriteButtonUI(value)
        }.store(in: &cancellables)
    }
    override func prepareForReuse() {
        self.reusableCancellables = Set<AnyCancellable>()
    }

    @IBAction func favoritesButtonTapped(_ sender: Any) {
        //favorite 여부 변경
        let newValue = !isFavorite.value
        isFavorite.send(newValue)
    }
    
    /// - Parameters:
    ///   - firstText: 표제어 텍스트
    ///   - secondText: 뜻 텍스트
    ///   - isFavorite: Favorite 여부
    /// - Returns: isFavorite 변경 값 publisher
    func configure(firstText: String, secondText: String, isFavorite: Bool)  {
        self.firstLabel.text = firstText
        self.secondLabel.text = secondText
        self.isFavorite.send(isFavorite)
    }

    ///favorite 아이콘 UI를 갱신한다.
    func setFavoriteButtonUI(_ isFavorite: Bool) {
        if !isFavorite {
            favoriteButton.setImage(linedStarImage, for: .normal)
            favoriteButton.tintColor = .colorTeal02
        } else {
            favoriteButton.setImage(filledStarImage, for: .normal)
            favoriteButton.tintColor = .colorGold
        }
    }
}
