//
//  Methodology.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct Methodology {
    var name : String
    var description : String
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    static func fromJson(json: [String : Any]) -> Methodology {
        return Methodology(
            name: json["name"] as! String,
            description: json["description"] as! String
        )
    }
}
