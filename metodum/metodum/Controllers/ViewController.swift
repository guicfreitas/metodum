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

extension UIViewController {
    func showErrorScreen(errorMessage: String) {
        var image = ""
        var title = ""
        var details = ""
        
        if errorMessage.contains("Network error") {
            image = "sad_error"
            title = "Network Error"
            details = errorMessage
        } else if errorMessage.contains("Upload Failure") {
            image = "sad_cloud"
            title = "Upload Failure"
            details = errorMessage
        } else {
            image = "sad_ice_cream"
            title = "an uknown error ocurred"
            details = "errorMessage"
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let errorScreenViewController = storyboard.instantiateViewController(withIdentifier: "errorScreen") as! ShowErrorViewController
        
        errorScreenViewController.isModalInPresentation = true
        errorScreenViewController.errorImageName = image
        errorScreenViewController.errorTitle.text = title
        errorScreenViewController.errorDetails.text = details
        
        self.present(errorScreenViewController, animated: true, completion: nil)
    }
}



