//
//  CardItemView.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/19/24.
//

import UIKit

protocol CardItemViewDelegate: AnyObject {
    func cardItemViewFavoriteButtonToggled(at index: Int, _ marked: Bool)
}

class CardItemView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    let linedStarImage: UIImage? = .init(systemName: "star")
    let filledStarImage: UIImage? = .init(systemName: "star.fill")
    
    var index: Int = 0
    
    ///즐겨찾기 여부
    var isFavorite: Bool = false {
        didSet {
            //값이 바뀌면 UI 갱신하고, delegate에 전달
            updateFavoriteUI()
        }
    }
    
    weak var delegate: CardItemViewDelegate?
    
    func configure(index: Int, text: String, font: UIFont?, isFavorite: Bool, delegate: CardItemViewDelegate) {
        self.index = index
        self.label.text = text
        if let font {
            self.label.font = font
        }
        
        self.isFavorite = isFavorite
        self.delegate = delegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()

    }

    func customInit() {
        if let view = Bundle.main.loadNibNamed("\(CardItemView.self)", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
        
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.colorGrey01.cgColor
        updateFavoriteUI()
    }
    
    
    func updateFavoriteUI() {
        if !isFavorite {
            favoriteButton.setImage(linedStarImage, for: .normal)
            favoriteButton.tintColor = .colorTeal02
        } else {
            favoriteButton.setImage(filledStarImage, for: .normal)
            favoriteButton.tintColor = .colorGold
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        isFavorite = !isFavorite
        delegate?.cardItemViewFavoriteButtonToggled(at: index, isFavorite)
    }
    
}
