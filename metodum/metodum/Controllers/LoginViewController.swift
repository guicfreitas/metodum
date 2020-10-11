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
    @IBOutlet weak var signInButtonView: UIView!
    @IBOutlet weak var appleSignInButtonView: UIView!
    
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
        signInButtonView.layer.cornerRadius = 10
        appleSignInButtonView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
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
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
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
        
        performSegue(withIdentifier: "Login to Register Screen", sender: nil)
        
        /*let alert = UIAlertController(title: "Register", message: "Register Account",preferredStyle: .alert)
        
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
        
        present(alert, animated: true, completion: nil)*/
    }
    
    @IBAction func appleSignInButton(_ sender: Any) {
        showAuthorizationController()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Entrar"
        navigationController?.navigationBar.backgroundColor = UIColor(named:"Blue")
        navigationController?.isNavigationBarHidden = false
    }
    
    private func clearNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.backgroundColor = UIColor(named:"BlackBody")
        navigationItem.setRightBarButtonItems([], animated: false)
        navigationItem.title = ""
    }
    
    private func showAuthorizationController() {
        guard let request = getAppleSignInRequest() else {return}
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func getAppleSignInRequest() -> ASAuthorizationRequest? {
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
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
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

/*class BackgroundView : UIView {
    override func draw(_ rect: CGRect) {
        print("chamou")
        
        // This code was generated by Trial version of PaintCode, therefore cannot be used for commercial purposes.
        // http://www.paintcodeapp.com

        // This code was generated by Trial version of PaintCode, therefore cannot be used for commercial purposes.
        // http://www.paintcodeapp.com

        //// Color Declarations
        let fillColor = UIColor(named: "Blue")

        //// layer101
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 123.04))
        bezierPath.addCurve(to: CGPoint(x: 2.16, y: -41), controlPoint1: CGPoint(x: 0, y: -32.69), controlPoint2: CGPoint(x: 0.12, y: -41))
        bezierPath.addCurve(to: CGPoint(x: 449.64, y: -20.82), controlPoint1: CGPoint(x: 8.64, y: -40.93), controlPoint2: CGPoint(x: 449.16, y: -21.04))
        bezierPath.addCurve(to: CGPoint(x: 449.88, y: 101.67), controlPoint1: CGPoint(x: 449.88, y: -20.6), controlPoint2: CGPoint(x: 450, y: 34.53))
        bezierPath.addLine(to: CGPoint(x: 449.52, y: 223.79))
        bezierPath.addLine(to: CGPoint(x: 437.51, y: 218.89))
        bezierPath.addCurve(to: CGPoint(x: 381.22, y: 201.98), controlPoint1: CGPoint(x: 422.15, y: 212.66), controlPoint2: CGPoint(x: 397.9, y: 205.32))
        bezierPath.addCurve(to: CGPoint(x: 203.81, y: 209.62), controlPoint1: CGPoint(x: 321.44, y: 189.96), controlPoint2: CGPoint(x: 258.79, y: 192.63))
        bezierPath.addCurve(to: CGPoint(x: 111.03, y: 245.3), controlPoint1: CGPoint(x: 193.25, y: 212.96), controlPoint2: CGPoint(x: 162.04, y: 224.9))
        bezierPath.addCurve(to: CGPoint(x: 17.16, y: 281.58), controlPoint1: CGPoint(x: 63.86, y: 264.22), controlPoint2: CGPoint(x: 27.61, y: 278.17))
        bezierPath.addLine(to: CGPoint(x: 0, y: 287))
        bezierPath.addLine(to: CGPoint(x: 0, y: 123.04))
        bezierPath.close()
        fillColor!.setFill()
        bezierPath.fill()
    }
}*/
