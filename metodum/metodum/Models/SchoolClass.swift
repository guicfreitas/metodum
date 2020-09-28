//
//  SchoolClass.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct SchoolClass {
    var name : String
    var schoolName : String
    var description : String
    
    init(name : String, schoolName: String, description: String) {
        self.name = name
        self.schoolName = schoolName
        self.description = description
    }
    
    static func fromJson(json : [String : Any]) -> SchoolClass {
        print(json)
        return SchoolClass(
            name: json["name"] as! String,
            schoolName: json["schoolName"] as! String,
            description: json["description"] as! String
            // ajeitar aaqui pq ele n ta lendo o school name
        )
    }
    
    func toJson() -> [String : Any] {
        return [
            "name" : self.name,
            "schoolName" : self.schoolName,
            "description" : self.description,
        ]
    }
}
