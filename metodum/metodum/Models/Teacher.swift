//
//  Teacher.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

import Foundation

struct Teacher {
    var name : String
    var classes : [SchoolClass]
    
    init(name: String, classes: [SchoolClass]) {
        self.name = name
        self.classes = classes
    }
    
    /*static func fromJson(json: [String,Any]) {
        return Teacher(
            name: json["name"],
            classes: <#T##[SchoolClass]#>
        )
        
    }*/
}
