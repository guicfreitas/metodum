//
//  User.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct User {
    var uid : String
    var email : String
    var name : String
    
    init(uid: String, email: String, name: String) {
        self.uid = uid
        self.email = email
        self.name = name
    }
}
