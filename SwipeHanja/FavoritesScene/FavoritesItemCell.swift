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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoritesButtonTapped(_ sender: Any) {
    }
}
