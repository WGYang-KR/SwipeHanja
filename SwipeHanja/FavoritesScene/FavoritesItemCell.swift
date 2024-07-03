//
//  FavoritesItemCell.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 6/24/24.
//

import UIKit

class FavoritesItemCell: UITableViewCell {

    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    let linedStarImage: UIImage? = .init(systemName: "star")
    let filledStarImage: UIImage? = .init(systemName: "star.fill")
    
    weak var favoriteItem: FavoriteItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoritesButtonTapped(_ sender: Any) {
        guard let favoriteItem else { return }
        let newValue = !favoriteItem.isFavorite
        favoriteItem.updateFavorite(newValue)
        setFavoriteButtonUI(newValue)
    }
    
    func configure(favoriteItem: FavoriteItem) {
        self.favoriteItem = favoriteItem
        firstLabel.text = favoriteItem.cardItem.frontWord
        secondLabel.text = favoriteItem.cardItem.backWord
        setFavoriteButtonUI(favoriteItem.isFavorite)
    }
    
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
