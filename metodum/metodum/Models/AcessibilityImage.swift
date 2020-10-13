//
//  AcessibilityImage.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 01/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

struct AcessibilityImage {
    var data : Data
    var acessibilityLabel_pt : String
    var acessibilityHint_pt : String
    var acessibilityLabel_en : String
    var acessibilityHint_en : String
    
    init(data : Data, acessibilityLabel_pt : String, acessibilityLabel_en : String,acessibilityHint_pt: String, acessibilityHint_en: String) {
        self.data = data
        self.acessibilityLabel_pt = acessibilityLabel_pt
        self.acessibilityHint_pt = acessibilityHint_pt
        self.acessibilityLabel_en = acessibilityLabel_en
        self.acessibilityHint_en = acessibilityHint_en
    }
}
