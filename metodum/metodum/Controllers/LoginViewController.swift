//  LoginViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = AuthService.getUser() {
            print("tem user logado, performando segue")
            //print(user?.name)
            self.performSegue(withIdentifier: "Login to Main Screen", sender: user)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Login to Main Screen" {
            let viewController = segue.destination as! ViewController
            viewController.user = sender as? User
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        guard let email = emailField.text else {
            alertError(message: "Error reading Email Field")
            return
        }
        
        guard let password = passwordField.text else {
            alertError(message: "Error reading Password Field")
            return
        }
        
        if !email.isEmpty && !password.isEmpty {
            AuthService.signInWithEmailAndPassword(email: email, password: password) { (error,user) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    self.performSegue(withIdentifier: "Login to Main Screen", sender: user)
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let alert = UIAlertController(title: "Register", message: "Register Account",preferredStyle: .alert)
        
        alert.addTextField { textEmail in
          textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
          textPassword.isSecureTextEntry = true
          textPassword.placeholder = "Enter your password"
        }
        
        alert.addTextField { (textName) in
            textName.placeholder = "Enter your full name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            let nameField = alert.textFields![2]
            
            if let email = emailField.text, let password = passwordField.text, let name = nameField.text {
                if !email.isEmpty && !password.isEmpty && !name.isEmpty{
                    AuthService.createUserWithEmailAndPassword(email: email, password: password, name: name) { (error,user) in
                        print("closure createUser with email")
                        if let errorMessage = error {
                            self.alertError(message: errorMessage)
                        } else {
                            self.performSegue(withIdentifier: "Login to Main Screen", sender: user)
                        }
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func alertError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        }
    }
}
