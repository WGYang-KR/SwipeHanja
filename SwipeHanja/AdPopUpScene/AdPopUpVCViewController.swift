//
//  AdPopUpVCViewController.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 1/5/25.
//

import UIKit

class AdPopUpVCViewController: UIViewController {
    @IBOutlet var backBoxView: UIView!
    
    var showADTapped: (() -> Void)?
    var goToBuyTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBoxView.layer.cornerRadius = 12.0
        // Do any additional setup after loading the view.
    }
    @IBAction func showADSelected(_ sender: Any) {
        showADTapped?()
    }
    
    @IBAction func goToBuySelected(_ sender: Any) {
        goToBuyTapped?()
    }
    
}
