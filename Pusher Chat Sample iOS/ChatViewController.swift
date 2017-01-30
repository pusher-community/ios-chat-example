//
//  ChatViewController.swift
//  Pusher Chat Sample iOS
//
//  Created by Zan Markan on 30/01/2017.
//  Copyright © 2017 Pusher. All rights reserved.
//

import Foundation
import UIKit
import PusherSwift
import AlamofireImage
import Alamofire

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let MESSAGES_ENDPOINT = "http://localhost:3000/messages"

    @IBOutlet var message: UITextField!
    @IBAction func send(_ sender: Any) {
        
        if(message.hasText){
            postMessage(name: twitterHandle, message: message.text!)
        }
        
    }
    @IBOutlet var messageTable: UITableView!
    
    var twitterHandle: String = "Anonymous"
    
    var pusher: Pusher?
    
    var array: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.messageTable.dataSource = self
        messageTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        

        pusher = Pusher(
            key: "YOUR_PUSHER_KEY"
        )
        
        // subscribe to channel and bind to event
        let channel = pusher!.subscribe("chatroom")
        
        let _ = channel.bind(eventName: "new_message", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                
                let text = data["text"] as! String
                let author = data["name"] as! String
                
                let message = Message(author: author, message: text)
        
                self.array.add(message)
    
                    DispatchQueue.main.async{
                        self.messageTable.reloadData()
                        let indexPath = IndexPath(item: self.array.count-1, section: 0)
                        self.messageTable.scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: true)
                    }
            }
        })
        
        pusher!.connect()
        
        
        let channel = pusher!.subscribe("chatroom")
        let _ = channel.bind(eventName: "new_message", callback: { (data: Any?) -> Void in
            
            if let data = data as? [String: AnyObject] {
                
                let text = data["text"] as! String
                let author = data["name"] as! String
                print(author + ": " + text)
            }
        })
        pusher!.connect()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        
        let message = array.object(at: indexPath.row) as! Message
      
        cell.authorName.text = message.author
        cell.messageText.text = message.message
        
        let imageUrl = URL(string: "https://twitter.com/" + message.author + "/profile_image")
        cell.authorAvatar.af_setImage(withURL: imageUrl!)
        return cell
    }
    
  
    
    
//    func twitterHandle(twitterHandle: String){
//        self.twitterHandle = twitterHandle
//    }
    
    func postMessage(name: String, message: String){
        
        let params: Parameters = [
            "name": name,
            "text": message
        ]
        
        Alamofire.request(ChatViewController.MESSAGES_ENDPOINT, method: .post, parameters: params).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                print("Validation successful")
            case .failure(let error):
                print(error)
            }
            
        }
    
    }
}
