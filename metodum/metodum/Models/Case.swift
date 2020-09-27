//
//  Case.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 25/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct Case {
    var name: String
    var methodology: String
    var description: String
    
    init(name: String, methodology: String, description: String) {
        self.name = name
        self.methodology = methodology
        self.description = description
    }
    
    static func fromJson(json: [String:Any]) -> Case {
        return Case(
            name: json["name"] as! String,
            methodology: json["methodology"] as! String,
            description: json["description"] as! String
        )
    }
    
    func toJson() -> [String:Any]{
        return [
            "name": self.name,
            "methodology": self.methodology,
            "description": self.description
        ]
    }
}

