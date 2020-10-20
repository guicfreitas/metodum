//
//  EmptyCollectionViewCell.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 20/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
    var message : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("empty cell message", comment: "")
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor(named: "Blue")
        self.contentView.addSubview(message)
        self.message.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.message.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.message.trailingAnchor.constraint(greaterThanOrEqualTo: self.contentView.trailingAnchor, constant: 5).isActive = true
        self.message.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        self.message.textRect(forBounds: self.contentView.bounds, limitedToNumberOfLines: 3)
        self.layer.cornerRadius = 20
        self.contentView.layer.cornerRadius = 20
        self.contentView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
