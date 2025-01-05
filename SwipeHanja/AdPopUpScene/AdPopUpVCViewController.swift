//
//  AdPopUpVCViewController.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 1/5/25.
//

import UIKit

class AdPopUpVCViewController: UIViewController {
    @IBOutlet var backBoxView: UIView!
    
    var closeTapped: (() -> Void)?
    var goToBuyTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBoxView.layer.cornerRadius = 12.0
        // Do any additional setup after loading the view.
    }
    @IBAction func closeSelected(_ sender: Any) {
        closeTapped?()
    }
    
    @IBAction func goToBuySelected(_ sender: Any) {
        goToBuyTapped?()
    }
    
}
