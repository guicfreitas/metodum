//
//  Teacher.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct Teacher {
    var uid: String
    var name: String
    var email: String
    var imageName: String
    
    init(uid: String,name: String, email: String, imageName: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.imageName = imageName
    }
    
    static func fromJson(json: [String: Any]) -> Teacher{
        return Teacher(
            uid: json["uid"] as! String,
            name: json["name"] as! String,
            email: json["email"] as! String,
            imageName: json["imageName"] as! String
        )
    }
    
    func toJson() -> [String: Any] {
        return [
            "uid" : self.uid,
            "name" : self.name,
            "email": self.email,
            "imageName": self.imageName
        ]
    }
}
