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
    
    var loadingSpinnerView : UIView!
    var language = Locale.current.languageCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeLoadSpinner()
        clearNavigationBar()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        signUpButtonBackgroundView.layer.cornerRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Register to Main Screen" {
            let viewController = segue.destination as! ViewController
            viewController.user = sender as? User
        }
    }
    
    @IBAction func returnToLoginButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, !email.isEmpty, !password.isEmpty, !name.isEmpty, !confirmPassword.isEmpty {
            showLoadSpinner()
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
                let message = (language == "pt") ? "A senha foi confirmada errada" : "The confirm password must be equal to the password"
                self.alertError(message: message)
            }
        } else {
            let message = (language == "pt") ? "Preencha todos os campos" : "Fill all the text fields"
            self.alertError(message: message)
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -50
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("register", comment: "")
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false
    }
    
    private func clearNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationItem.title = ""
    }
    
    func showLoadSpinner() {
        loadingSpinnerView = UIView.init(frame: self.view.bounds)
        loadingSpinnerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = loadingSpinnerView.center
        
        DispatchQueue.main.async {
            self.loadingSpinnerView.addSubview(ai)
            self.view.addSubview(self.loadingSpinnerView)
        }
    }
    
    func removeLoadSpinner() {
        DispatchQueue.main.async {
            self.loadingSpinnerView?.removeFromSuperview()
            self.loadingSpinnerView = nil
        }
    }
}
