//
//  CasesCollectionViewCell.swift
//  metodum
//
//  Created by Radija Praia on 22/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class CasesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var caseTitle: UILabel!
    @IBOutlet weak var caseSubtitle: UILabel!
    @IBOutlet weak var caseImage: UIImageView!
    
    override func layoutSubviews() {
            // cell rounded section
            self.layer.cornerRadius = 12
           
            self.layer.masksToBounds = true
            
            // cell shadow section
            self.contentView.layer.cornerRadius = 12.0
            self.contentView.layer.borderWidth = 5.0
            self.contentView.layer.borderColor = UIColor.clear.cgColor
            self.contentView.layer.masksToBounds = true
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.layer.shadowRadius = 6.0
            self.layer.shadowOpacity = 0.35
            self.layer.cornerRadius = 12.0
            self.layer.masksToBounds = false
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

    
}
