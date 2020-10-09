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
        self.methodImage.image = UIImage(data: image.data)
        self.methodImage.isAccessibilityElement = true
        self.methodImage.accessibilityLabel = image.acessibilityLabel
        self.methodImage.accessibilityHint = image.acessibilityHint
    }
}
