//
//  ViewController.swift
//  metodum
//
//  Created by João Guilherme on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImagesRepository.updateImageMetaData(image: "Flipped_Classroom_Square.png")
        //self.navigationController?.navigationBar.isHidden = true
        //setNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    /*func setNavigationBar() {
        self.navigationItem.title = "Turmas"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
    }
    
    @objc private func signOut() {
        AuthService.signOut { (error) in
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }*/
}



