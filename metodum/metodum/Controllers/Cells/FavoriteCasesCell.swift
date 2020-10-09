//
//  FavoriteCasesCell.swift
//  metodum
//
//  Created by João Guilherme on 08/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class FavoriteCasesCell: UICollectionViewCell {
    
    @IBOutlet weak var caseImage: UIImageView!
    
    func setImage(image: AcessibilityImage) {
        self.caseImage.image = UIImage(data: image.data)
        self.caseImage.isAccessibilityElement = true
        self.caseImage.accessibilityLabel = image.acessibilityLabel
        self.caseImage.accessibilityHint = image.acessibilityHint
    }
}
