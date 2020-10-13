
//  Case.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 25/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct Case {
    var uid: String
    var image: String
    var title_en: String
    var title_pt: String
    var subtitle_en: String
    var subtitle_pt: String
    var about_en: String
    var about_pt: String
    var result_pt: String
    var result_en: String
    
    init(uid : String, image: String, title_en: String, title_pt: String, subtitle_en: String, subtitle_pt: String, about_en: String, about_pt: String, result_pt: String, result_en: String) {
        self.uid = uid
        self.image = image
        self.title_en = title_en
        self.title_pt = title_pt
        self.subtitle_en = subtitle_en
        self.subtitle_pt = subtitle_pt
        self.about_en = about_en
        self.about_pt = about_pt
        self.result_pt = result_pt
        self.result_en = result_en
    }
    
    static func fromJson(json: [String:Any]) -> Case {
        return Case(
            uid: json["uid"] as! String,
            image: json["image"] as! String,
            title_en: json["title_en"] as! String,
            title_pt: json["title_pt"] as! String,
            subtitle_en: json["subtitle_en"] as! String,
            subtitle_pt: json["subtitle_pt"] as! String,
            about_en: json["about_en"] as! String,
            about_pt: json["about_pt"] as! String,
            result_pt: json["result_pt"] as! String,
            result_en: json["result_en"] as! String
        )
    }
    
    func toJson() -> [String:Any] {
        return [
            "uid": self.uid,
            "image": self.image,
            "title_en": self.title_en,
            "title_pt": self.title_pt,
            "subtitle_pt": self.subtitle_pt,
            "subtitle_en": self.subtitle_en,
            "about_pt": self.about_pt,
            "about_en": self.about_en,
            "result_pt": self.result_pt,
            "result_en": self.result_en
        ]
    }
}

let acessibilities = [
    "cases_yellow.png": ["Yellow themed image of a classroom","The illustration represents a classroom with yellow walls and a blackboard showing the design of a lamp and notes. In front of the board there are four students of different ethnicities, two of whom are men and the other two are women. Students are pointing to the blackboard and looking engaged in the activity."],
    
    "cases_blue.png": ["Blue themed image of a classroom","The illustration represents a classroom with blue walls and a blackboard showing the design of a lamp and notes. In front of the board there are four students of different ethnicities, two of whom are men and the other two are women. Students are pointing to the blackboard and looking engaged in the activity."],
    
    "cases_purple.png": ["Purple themed image of a classroom","The illustration represents a classroom with purple walls and a blackboard showing the design of a lamp and notes. In front of the board there are four students of different ethnicities, two of whom are men and the other two are women. Students are pointing to the blackboard and looking engaged in the activity."],
    
    "cases_orange.png": ["Orange themed image of a classroom","The illustration represents a classroom with orange walls and a blackboard showing the design of a lamp and notes. In front of the board there are four students of different ethnicities, two of whom are men and the other two are women. Students are pointing to the blackboard and looking engaged in the activity."],
    
    "cases_white.png": ["White themed image of a classroom","The illustration represents a classroom with white walls and a blackboard showing the design of a lamp and notes. In front of the board there are four students of different ethnicities, two of whom are men and the other two are women. Students are pointing to the blackboard and looking engaged in the activity."],
    
    "cases_grey.png": ["Grey themed image of a classroom","The illustration represents a classroom with greyish blue walls and a blackboard showing the design of a lamp and notes. In front of the board there are four students of different ethnicities, two of whom are men and the other two are women. Students are pointing to the blackboard and looking engaged in the activity."],
]
