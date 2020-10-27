//
//  EnterAccountCasesViewController.swift
//  metodum
//
//  Created by João Guilherme on 27/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit
import AuthenticationServices

class EnterAccountCasesViewController: UIViewController {

    @IBOutlet weak var appleButtonStackView: UIStackView!
    @IBOutlet weak var enterButton: UIButton!
    
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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
