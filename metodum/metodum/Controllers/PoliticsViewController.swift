//
//  PoliticsViewController.swift
//  metodum
//
//  Created by João Guilherme on 26/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class PoliticsViewController: UIViewController {
    @IBOutlet weak var acceptButton: UIButton!
    var callback : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptButton.layer.cornerRadius = 10
    }
    
    @IBAction func acceptedButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
        callback?()
    }
}

