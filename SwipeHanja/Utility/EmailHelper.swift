//
//  EmailHelper.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 5/4/24.
//

import Foundation
import UIKit
import MessageUI

class EmailHelper: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailHelper()
    private override init() {
        //
    }
    
    func sendEmail(subject:String, body:String, to:String){
        if !MFMailComposeViewController.canSendMail() {
            print("No mail account found")
            // Todo: Add a way to show banner to user about no mail app found or configured
            // Utilities.showErrorBanner(title: "No mail account found", subtitle: "Please setup a mail account")
            return //EXIT
        }
        
        let picker = MFMailComposeViewController()
        
        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: false)
        picker.setToRecipients([to])
        picker.mailComposeDelegate = self
        
        UIViewController.getTopViewController()?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        UIViewController.getTopViewController()?.dismiss(animated: true, completion: nil)
    }
    
   
}
