//
//  User.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct User {
    var uuid : String
    var email : String
    
    init(uuid: String, email: String) {
        self.uuid = uuid
        self.email = email
    }
}
