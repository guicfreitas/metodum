//
//  MethodDetailViewController.swift
//  metodum
//
//  Created by Radija Praia on 04/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit
import QuickLook

class MethodDetailViewController: UIViewController {

    @IBOutlet weak var howToApply: UITextView!
    @IBOutlet weak var about: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    var selectedMethod: Methodology?
    var persistedImagesNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        if let methodObject = selectedMethod {
            navigationItem.title = methodObject.name
            
            self.about.text = methodObject.description
            self.howToApply.text = methodObject.description
               
            self.about.isAccessibilityElement = true
            self.about.accessibilityLabel = methodObject.description
            
            self.howToApply.isAccessibilityElement = true
            self.howToApply.accessibilityLabel = methodObject.description
            
            self.persistedImagesNames = DeviceDataPersistenceService.persistedImagesNames[.methodsImages]!
            
            if self.persistedImagesNames.contains(methodObject.methodFullImage) {
                if let image = DeviceDataPersistenceService.getImage(named: methodObject.methodFullImage, on: .methodsImages) {
                    self.image.image = UIImage(data: image.data)
                    self.image.isAccessibilityElement = true
                    self.image.accessibilityLabel = image.acessibilityLabel
                    self.image.accessibilityHint = image.acessibilityHint
                }
            } else {
                ImagesRepository.getMethod(image: methodObject.methodFullImage) { (error, acessibilityImage) in
                    print("is main Thread ? \(Thread.isMainThread)")
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        if let image = acessibilityImage {
                            self.image.image = UIImage(data: image.data)
                            self.image.isAccessibilityElement = true
                            self.image.accessibilityLabel = image.acessibilityLabel
                            self.image.accessibilityHint = image.acessibilityHint
                            DeviceDataPersistenceService.write(acessibilityImage: image, named: methodObject.methodFullImage, on: .methodsImages)
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
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
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
        let customItem = SharePDFActivity(title: "Export PDF", image: UIImage(named: "doc.text")) { sharedItems in
            if let methodObject = self.selectedMethod {
                createPrintMethodFormatter(selectedMethod: methodObject)
            }
            self.openQlPreview()
        }
        
        let items = ["hue"]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: [customItem])

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func clearNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationItem.setRightBarButtonItems([], animated: false)
        navigationItem.title = ""
    }
    
    func openQlPreview() {
        let previoew = QLPreviewController.init()
        previoew.dataSource = self
        previoew.delegate = self
        self.present(previoew, animated: true, completion: nil)
    }
}

