//
//  WordListItemCell.swift
//  SwipeHanja
//
//  Created by WG-Yang on 5/16/24.
//

import UIKit
import Combine

class WordListItemCell: UITableViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    let checkMarkImage =   UIImage(systemName: "checkmark.seal.fill")
    
    var cancellables = Set<AnyCancellable>()
    
    let selectBtnTappedSubject = PassthroughSubject<Void,Never>()
    
    func configure(index: Int, firstText: String, secondText: String, checked: Bool) {
        indexLabel.text = String(index)
        firstLabel.text = firstText
        secondLabel.text = secondText
        checkMarkImageView.image  = checked ? checkMarkImage : nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.backgroundColor = .clear
        configure(index: 0, firstText: "", secondText: "", checked: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        cancellables.removeAll()
        configure(index: 0, firstText: "", secondText: "", checked: false)
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        selectBtnTappedSubject.send(Void())
    }
}
