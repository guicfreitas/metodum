
//  Methodology.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct Methodology {
    var uid : String
    var name_pt : String
    var name_en : String
    var about_pt : String
    var about_en : String
    var howToApply_pt : String
    var howToApply_en : String
    var methodFullImage : String
    var methodSquareImage : String
    var clicksCount : Int
    
    init(uid : String, name_pt: String, name_en: String, about_pt: String, about_en: String, howToApply_pt: String, howToApply_en: String, methodFullImage: String,methodSquareImage: String,clicksCount : Int = 0) {
        self.uid = uid
        self.name_pt = name_pt
        self.name_en = name_en
        self.about_pt = about_pt
        self.about_en = about_en
        self.howToApply_pt = howToApply_pt
        self.howToApply_en = howToApply_en
        self.methodFullImage = methodFullImage
        self.methodSquareImage = methodSquareImage
        self.clicksCount = clicksCount
    }
    
    static func fromJson(json: [String : Any]) -> Methodology {
        return Methodology(
            uid: json["uid"] as! String,
            name_pt: json["name_pt"] as! String,
            name_en: json["name_en"] as! String,
            about_pt: json["about_pt"] as! String,
            about_en: json["about_en"] as! String,
            howToApply_pt: json["howToApply_pt"] as! String,
            howToApply_en: json["howToApply_en"] as! String,
            methodFullImage: json["methodFullImage"] as! String,
            methodSquareImage: json["methodSquareImage"] as! String,
            clicksCount: json["clicksCount"] as? Int ?? 0
        )
    }
}
