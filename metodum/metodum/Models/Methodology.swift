
//  Methodology.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct Methodology {
    var uid : String
    var name : String
    var description : String
    var methodImage : String
    var clicksCount : Int
    
    init(uid : String, name: String, description: String, methodImage: String,clicksCount : Int = 0) {
        self.uid = uid
        self.name = name
        self.description = description
        self.methodImage = methodImage
        self.clicksCount = clicksCount
    }
    
    static func fromJson(json: [String : Any]) -> Methodology {
        return Methodology(
            uid: json["uid"] as! String,
            name: json["name"] as! String,
            description: json["description"] as! String,
            methodImage: json["methodImage"] as! String,
            clicksCount: json["clicksCount"] as? Int ?? 0
        )
    }
    
    /*func toJson() -> [String:Any] {
        return [
            "name": self.name,
            "description": self.description
        ]
    }*/
}
