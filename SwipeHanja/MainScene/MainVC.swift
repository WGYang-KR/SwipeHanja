//
//  ViewController.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapMoveBtn(_ sender: Any) {
        let vc = SwipeCardVC()
        presentFull(vc, animated: true)
    }
    
}

