//
//  AlertHelper.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 5/6/24.
//

import UIKit

class AlertHelper {
    
    static func alertConfirm(baseVC: UIViewController,
                      title:String,
                      message: String,
                      confirmCompletion: @escaping ()->Void,
                      cancelCompletion: (()->Void)? = nil,
                      animated: Bool = true) {
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (_) in
            confirmCompletion()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in
            cancelCompletion?()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

               
        baseVC.present(alert, animated: animated, completion: nil)
    }
    
    static func alertInform(baseVC: UIViewController,
                      title:String,
                      message: String,
                      confirmCompletion: @escaping ()->Void,
                      animated: Bool = true) {
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (_) in
            confirmCompletion()
        }
        alert.addAction(confirmAction)
        
        baseVC.present(alert, animated: animated, completion: nil)
    }
}
