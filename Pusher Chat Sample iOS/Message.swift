//
//  Message.swift
//  Pusher Chat Sample iOS
//
//  Created by Zan Markan on 31/01/2017.
//  Copyright © 2017 Pusher. All rights reserved.
//

import Foundation

struct Message {
    
    let author: String
    let message: String
    
    init(author: String, message: String) {
        self.author = author
        self.message = message
    }
}
