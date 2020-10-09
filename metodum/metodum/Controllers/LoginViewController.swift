//  LoginViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit
import CryptoKit
import AuthenticationServices

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        if let user = AuthService.getUser() {
            print("tem user logado, performando segue")
            //print(user?.name)
            /*AuthService.signOut { (_) in
                print("foi")
            }*/
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login to Main Screen", sender: user)
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
                                        self.performSegue(withIdentifier: "Login to Main Screen", sender: currentUser)
                                    }
                                }
                            }
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
    
    @IBAction func appleSignInButton(_ sender: Any) {
        showAuthorizationController()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private func showAuthorizationController() {
        guard let request = getAppleSignInRequest() else {return}
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func getAppleSignInRequest() -> ASAuthorizationRequest? {
        AuthService.currentNonce = randomNonceString()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        if let nonce = AuthService.currentNonce {
            request.nonce = sha256(nonce)
            return request
        }
        
        return nil
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
      }
        return result
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let appleIDTokenString = String(data: appleIDToken, encoding: .utf8) {
         
            AuthService.signInWith(appleIDTokenString: appleIDTokenString) { (error, user) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                    
                } else {
                    guard let currentUser = user else {return}
                    
                    if currentUser.name.isEmpty {
                        print("user display name vazio") // se o display name vem vazio, esse usuário já foi logado pelo menos uma vez no app
                        self.performSegue(withIdentifier: "Login to Main Screen", sender: user) 
                    } else {
                        print("user com display name") // no login apple, o displayName so vem uma vez, que e na primeira vez que o usuario loga com a conta no app
                        let teacher = Teacher(
                            uid: currentUser.uid,
                            name: currentUser.name,
                            email: currentUser.email,
                            imageName: ""
                        )
                        print("antes de inicializar")
                        // bota um loading aqui
                        TeachersCloudRepository.initialize(teacher: teacher) { (error, currentTeacher) in
                            if let errorMessage = error {
                                self.alertError(message: errorMessage)
                            } else {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "Login to Main Screen", sender: currentUser)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.alertError(message: error.localizedDescription)
    }
}
