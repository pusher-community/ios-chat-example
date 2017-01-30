//
//  ChatViewController.swift
//  Pusher Chat Sample iOS
//
//  Created by Zan Markan on 30/01/2017.
//  Copyright © 2017 Pusher. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {

    @IBOutlet var message: UITextField!
    @IBAction func send(_ sender: Any) {
        
        if(message.hasText){
            print(twitterHandle, ": ", message.text!)
        }
        
    }
    
    var twitterHandle: String = "Anonymous"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func twitterHandle(twitterHandle: String){
        self.twitterHandle = twitterHandle
    }
    
    
    
    
    
}
