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
            print(twitterHandle, ": ", message.text!)
        }
        
    }
    @IBOutlet var messageTable: UITableView!
    
    let CellIdentifier = "com.pusher.TableViewCell"
    
    var twitterHandle: String = "Anonymous"
    
    var pusher: Pusher?
    
    var array: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.messageTable.dataSource = self
        messageTable.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        

        let options = PusherClientOptions(
            host: .cluster("eu")
        )
        pusher = Pusher(
            key: "f400c100bb3d7301c79a",
            options: options
        )
        
        // subscribe to channel and bind to event
        let channel = pusher!.subscribe("my-channel")
        
        let _ = channel.bind(eventName: "my-event", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    self.array.add(message)
    
                    DispatchQueue.main.async{
                        self.messageTable.reloadData()
                        let indexPath = IndexPath(item: self.array.count-1, section: 0)
                        self.messageTable.scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: true)

                    }
                }
            }
        })
        
        pusher!.connect()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as UITableViewCell
//        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.text = array.object(at: indexPath.row) as! String
        return cell
    }
    
    
    
    func twitterHandle(twitterHandle: String){
        self.twitterHandle = twitterHandle
    }
    
    
    
    
    
}
