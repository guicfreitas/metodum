//
//  FavoriteMethodCell.swift
//  metodum
//
//  Created by João Guilherme on 08/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class FavoriteMethodCell: UICollectionViewCell {
    
    @IBOutlet weak var methodImage: UIImageView!
    
    func setImage(image: AcessibilityImage) {
        
        let language = Locale.current.languageCode
        
        self.methodImage.image = UIImage(data: image.data)
        self.methodImage.isAccessibilityElement = true
        
        self.methodImage.accessibilityLabel = (language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
        self.methodImage.accessibilityHint = (language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
    }
}
