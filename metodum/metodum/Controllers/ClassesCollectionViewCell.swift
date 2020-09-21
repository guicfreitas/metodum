//
//  ClassesCollectionViewCell.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class ClassesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func setCellData(schoolClass : SchoolClass) {
        print("foi")
        title.text = schoolClass.name
        subtitle.text = schoolClass.schoolName
        self.layer.cornerRadius = 12
    }
}
