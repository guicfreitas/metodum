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
    var acessibilityLabel : String
    var acessibilityHint : String
    
    init(data : Data, acessibilityLabel : String, acessibilityHint: String) {
        self.data = data
        self.acessibilityLabel = acessibilityLabel
        self.acessibilityHint = acessibilityHint
    }
}
