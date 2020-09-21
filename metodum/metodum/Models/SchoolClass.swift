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
    
    init(name : String, schoolName: String) {
        self.name = name
        self.schoolName = schoolName
    }
    
    static func fromJson(json : [String : Any]) -> SchoolClass {
        print(json)
        return SchoolClass(
            name: json["name"] as! String,
            schoolName: json["schoolName"] as? String ?? "" // ajeitar aaqui pq ele n ta lendo o school name
        )
    }
}
