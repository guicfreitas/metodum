//
//  ViewController.swift
//  metodum
//
//  Created by João Guilherme on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

var vSpinner : UIView?

class ViewController: UITabBarController {
    
    var user : User?
    var teacher : Teacher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = user else { return }
        
        if DeviceDataPersistenceService.directoryExists(named: .methodsImages) {
            print("methods images existe")
        } else {
            DeviceDataPersistenceService.createDirectory(named: .methodsImages)
        }
        
        if DeviceDataPersistenceService.directoryExists(named: .casesImages) {
            print("cases images existe")
        } else {
            DeviceDataPersistenceService.createDirectory(named: .casesImages)
        }
        
        TeachersCloudRepository.get(teacherId: currentUser.uid) { (error, teacher) in
            print("get Teacher Id is main thread ? \(Thread.current.isMainThread)")
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            } else {
                self.teacher = teacher
            }
        }
        //ImagesRepository.updateImageMetaData(image: "Flipped_Classroom_Square.png")
    }
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

extension UIViewController {
    func alertError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        }
    }
}

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}


