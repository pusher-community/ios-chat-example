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

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var message: UITextField!
    @IBAction func send(_ sender: Any) {
        
        if(message.hasText){
            postMessage(name: twitterHandle, message: message.text!)
        }
        
    }
    @IBOutlet var messageTable: UITableView!
    
    let CellIdentifier = "MessageCell"
    
    var twitterHandle: String = "Anonymous"
    
    var pusher: Pusher?
    
    var array: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.messageTable.dataSource = self
        messageTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        

        pusher = Pusher(
            key: "ed5b0a28bf1175148146"
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        
        let message = array.object(at: indexPath.row) as! Message
      
        cell.authorName.text = message.author
        cell.messageText.text = message.message
        cell.authorAvatar.downloadedFrom(link: "https://twitter.com/" + message.author + "/profile_image")
        return cell
    }
    
  
    
    
    func twitterHandle(twitterHandle: String){
        self.twitterHandle = twitterHandle
    }
    
    func postMessage(name: String, message: String){
    
        var request = URLRequest(url: URL(string: "http://localhost:3000/messages")!)
        request.httpMethod = "POST"
        
        //TODO:
        let postString = "name="+name+"&text="+message;
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
        }
        task.resume()
        
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
