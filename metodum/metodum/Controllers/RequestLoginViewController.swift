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

    @IBOutlet weak var appleButtonStackView: UIStackView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    var callback : (() -> ())?
    
    let appleSignInButton : ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        //button.addTarget(self, action: #selector(showAuthorizationController), for: .touchDown)
        button.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.layer.cornerRadius = 10
        appleButtonStackView.addArrangedSubview(appleSignInButton)
    }

    @IBAction func enterButtonPressed(_ sender: Any) {
        callback?()
        dismiss(animated: true, completion: nil)
    }
}
