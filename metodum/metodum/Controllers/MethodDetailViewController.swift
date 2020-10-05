//
//  MethodDetailViewController.swift
//  metodum
//
//  Created by Radija Praia on 04/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class MethodDetailViewController: UIViewController {

    @IBOutlet weak var howToApply: UITextView!
    @IBOutlet weak var about: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    var selectedMethod: Methodology?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        
        if let methodObject = selectedMethod {
            navigationItem.title = methodObject.name
            
            self.about.text = methodObject.description
            self.howToApply.text = methodObject.description

            // vou arrumar um jeito de cachear as imagens, pq ficar baixando as mesmas imagens várias vezes é uma sacanagem com o plano de dados do usuário
            DispatchQueue.main.async {
                ImagesRepository.getMethod(image: methodObject.methodImage) { (error, acessibilityImage) in
                    print("is main Thread ? \(Thread.isMainThread)")
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        if let image = acessibilityImage {
                            self.image.image = UIImage(data: image.data)
                        }
                    }
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        let addFavoriteMethod = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(setFavoriteMethod))
        
        let pdfConversionButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(convertMethodToPdf))
        
        addFavoriteMethod.tintColor = .systemOrange
        pdfConversionButton.tintColor = .systemOrange
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButtonItems([pdfConversionButton,addFavoriteMethod], animated: false)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func setFavoriteMethod() {
        let user = AuthService.getUser()
        if let teacher = user, let method = selectedMethod {
            TeachersCloudRepository.addMethodForTeacher(teacherUid: teacher.uid, method: method)
        }
    }
    
    @objc private func convertMethodToPdf() {
        // to com sono
    }
    
    private func clearNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationItem.setRightBarButtonItems([], animated: false)
        navigationItem.title = ""
    }
}
