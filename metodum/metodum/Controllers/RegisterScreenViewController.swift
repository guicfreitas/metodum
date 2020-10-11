//
//  RegisterScreenViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 10/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class RegisterScreenViewController: UIViewController {

    @IBOutlet weak var signUpButtonBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func returnToLoginButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        signUpButtonBackgroundView.layer.cornerRadius = 10
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(named: "Blue")
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor(named: "Blue")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearNavigationBar()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Cadastrar"
        navigationItem.hidesBackButton = true
        //navigationItem.backBarButtonItem?.tintColor = UIColor(named: "Blue")
        navigationController?.navigationBar.backgroundColor = UIColor(named:"Blue")
        navigationController?.isNavigationBarHidden = false
    }
    
    private func clearNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.backgroundColor = UIColor(named:"BlackBody")
        navigationItem.setRightBarButtonItems([], animated: false)
        navigationItem.title = ""
    }
}
