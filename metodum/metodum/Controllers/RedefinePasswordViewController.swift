//
//  RedefinePasswordViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class RedefinePasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        messageLabel.text = NSLocalizedString("forgot password message", comment: "")
        backButton.setTitle(NSLocalizedString("back", comment: ""), for: .normal)
        button.setTitle(NSLocalizedString("send email", comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        backButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearNavigationBar()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @IBAction func buttonPressed(_ sender: Any) {
        if let email = emailTextField.text, !email.isEmpty {
            AuthService.redefinePassword(for: email) { (error) in
                print("foi")
                print(email)
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                }
            }
        } else {
            self.alertError(message: NSLocalizedString("login input error", comment: ""))
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    private func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("forgot password", comment: "")
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false
    }
    
    private func clearNavigationBar() {
        navigationItem.title = ""
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
}
