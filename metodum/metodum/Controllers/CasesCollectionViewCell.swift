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
    
    var id: Int = 0
    
    func setImage (named: String){
        caseImage.image = UIImage(named: named)
        
    }
}
