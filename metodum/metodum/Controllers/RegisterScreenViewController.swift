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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
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
        
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, !email.isEmpty, !password.isEmpty, !name.isEmpty, !confirmPassword.isEmpty {
            
            if password == confirmPassword {
                AuthService.createUserWithEmailAndPassword(email: email, password: password, name: name) { (error,user) in
                    print("closure createUser with email")
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        if let currentUser = user {
                            let teacher = Teacher(
                                uid: currentUser.uid,
                                name: currentUser.name,
                                email: currentUser.email,
                                imageName: ""
                            )
                            print("antes de inicializar")
                            TeachersCloudRepository.initialize(teacher: teacher) { (error, currentTeacher) in
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "Register to Main Screen", sender: currentUser)
                                }
                            }
                        }
                    }
                }
            } else {
                self.alertError(message: "A senha foi confirmada errada")
            }
        }
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
