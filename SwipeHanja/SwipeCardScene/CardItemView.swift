//
//  CardItemView.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/19/24.
//

import UIKit

class CardItemView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    
    convenience init(text: String) {
        self.init(frame: .zero)
        label.text = text
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
    }

}
