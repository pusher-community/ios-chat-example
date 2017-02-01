//
//  LoginViewController.swift
//  Pusher Chat Sample iOS
//
//  Created by Zan Markan on 30/01/2017.
//  Copyright © 2017 Pusher. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var twitterHandle: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        if(twitterHandle.hasText){
            let messagesViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
            messagesViewController.twitterHandle = twitterHandle.text!
            self.present(messagesViewController, animated:true)
        }
        else{
            print("No text in textfield")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
