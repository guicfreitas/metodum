
//  Case.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 25/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct Case {
    var caseUid : String
    var caseTitle: String
    var caseSubtitle: String
    var caseImage: String
    var aboutCase: String
    var caseResult: String
    
    init(uid : String,caseTitle: String, caseSubtitle: String, caseImage: String, aboutCase: String, caseResult: String) {
        self.caseUid = uid
        self.caseTitle = caseTitle
        self.caseSubtitle = caseSubtitle
        self.caseImage = caseImage
        self.aboutCase = aboutCase
        self.caseResult = caseResult
    }
    
    static func fromJson(json: [String:Any]) -> Case {
        return Case(
            uid: json["caseUid"] as! String,
            caseTitle: json["caseTitle"] as! String,
            caseSubtitle: json["caseSubtitle"] as! String,
            caseImage: json["caseImage"] as! String,
            aboutCase: json["aboutCase"] as! String,
            caseResult: json["caseResult"] as! String
        )
    }
    
    func toJson() -> [String:Any] {
        return [
            "caseTitle": self.caseTitle,
            "caseSubtitle": self.caseSubtitle,
            "caseImage": self.caseImage,
            "aboutCase": self.aboutCase,
            "caseResult": self.caseResult,
            "caseUid" : self.caseUid
        ]
    }
}
