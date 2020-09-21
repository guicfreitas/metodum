//
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
        
        AuthService.verifyAuthentication { (user) in
            if let loggedUser = user {
                print("tem user logado, performando segue")
                self.performSegue(withIdentifier: "Login to Main Screen", sender: loggedUser)
            }
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
            AuthService.signInWithEmailAndPassword(email: email, password: password) { (error) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                }
            }
        }
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
