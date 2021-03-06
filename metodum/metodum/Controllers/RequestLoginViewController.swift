//
//  EnterAccountCasesViewController.swift
//  metodum
//
//  Created by João Guilherme on 27/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit
import AuthenticationServices

class RequestLoginViewController: UIViewController {

    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    var callback : (() -> ())?
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.layer.cornerRadius = 10
    }

    @IBAction func enterButtonPressed(_ sender: Any) {
        callback?()
        dismiss(animated: true, completion: nil)
    }
}
