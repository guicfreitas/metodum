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
    var user: User?
    var isFavorite = false
    var language = Locale.current.languageCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        if let currentUser = user {
            TeachersCloudRepository.getFavoriteMethodsUidsForTeacher(teacherUid: currentUser.uid) { (error, favoriteMethods) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    if let method = self.selectedMethod, let methods = favoriteMethods {
                        DispatchQueue.main.async {
                            if methods.contains(method.uid) {
                                self.navigationItem.rightBarButtonItems![1] = self.getFavoriteUIItemButtonWith(icon: "star.fill")
                                self.isFavorite = true
                            } else {
                                self.navigationItem.rightBarButtonItems![1] = self.getFavoriteUIItemButtonWith(icon: "star")
                            }
                        }
                    }
                }
            }
        }

        if let methodObject = selectedMethod {
            if language == "pt" {
                navigationItem.title = methodObject.name_pt
                self.about.text = methodObject.about_pt.replacingOccurrences(of: "\\n", with: "\n")
                self.howToApply.text = methodObject.howToApply_pt.replacingOccurrences(of: "\\n", with: "\n")
                   
                self.about.isAccessibilityElement = true
                self.about.accessibilityLabel = methodObject.about_pt
                
                self.howToApply.isAccessibilityElement = true
                self.howToApply.accessibilityLabel = methodObject.howToApply_pt
            } else {
                navigationItem.title = methodObject.name_en
                self.about.text = methodObject.about_en.replacingOccurrences(of: "\\n", with: "\n")
                self.howToApply.text = methodObject.howToApply_en.replacingOccurrences(of: "\\n", with: "\n")
                   
                self.about.isAccessibilityElement = true
                self.about.accessibilityLabel = methodObject.about_en
                
                self.howToApply.isAccessibilityElement = true
                self.howToApply.accessibilityLabel = methodObject.howToApply_en
            }
            
            self.persistedImagesNames = DeviceDataPersistenceService.persistedImagesNames[.methodsImages]!
            
            if self.persistedImagesNames.contains(methodObject.methodFullImage) {
                if let image = DeviceDataPersistenceService.getImage(named: methodObject.methodFullImage, on: .methodsImages) {
                    self.image.image = UIImage(data: image.data)
                    self.image.isAccessibilityElement = true
                    self.image.accessibilityLabel = (language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
                    self.image.accessibilityHint = (language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
                }
            } else {
                ImagesRepository.getMethod(image: methodObject.methodFullImage) { (error, acessibilityImage) in
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        if let image = acessibilityImage {
                            self.image.image = UIImage(data: image.data)
                            self.image.isAccessibilityElement = true
                            self.image.accessibilityLabel = (self.language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
                            self.image.accessibilityHint = (self.language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
                            DeviceDataPersistenceService.write(acessibilityImage: image, named: methodObject.methodFullImage, on: .methodsImages)
                        }
                    }
                }
            }
        }
    }
    
    private func setupNavigationBar() {
        let addFavoriteMethod = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(setFavoriteMethod))
        
        let pdfConversionButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(convertMethodToPdf))
        
        //addFavoriteMethod.isEnabled = false
        addFavoriteMethod.tintColor = .systemOrange
        pdfConversionButton.tintColor = .systemOrange
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButtonItems([pdfConversionButton,addFavoriteMethod], animated: false)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func setFavoriteMethod() {
        if let teacher = user, let methodObj = selectedMethod {
            if isFavorite {
                TeachersCloudRepository.removeMethodForTeacher(teacherUid: teacher.uid, favoriteMethodUid: methodObj.uid) { (error) in
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        self.navigationItem.rightBarButtonItems![1] = self.getFavoriteUIItemButtonWith(icon: "star")
                    }
                }
            } else {
                TeachersCloudRepository.addMethodForTeacher(teacherUid: teacher.uid, method: methodObj) { (error) in
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        self.navigationItem.rightBarButtonItems![1] = self.getFavoriteUIItemButtonWith(icon: "star.fill")
                    }
                }
            }
            isFavorite = !isFavorite
        }
    }
    
    @objc private func convertMethodToPdf() {
        let customItem = SharePDFActivity(title: (self.language == "pt") ? "Exportar PDF" : "Export PDF", image: UIImage(systemName: "arrow.down.doc")) { sharedItems in
            if let methodObject = self.selectedMethod {
                createPrintMethodFormatter(selectedMethod: methodObject)
            }
            self.openQlPreview()
        }
        
        var titleAC : String = ""
        var aboutTextAC : String = ""
        var howToAC : String = ""
        var aboutTitleAC : String = ""
        var howToApplyTitleAC : String = ""
        
        if let methodObject = selectedMethod {
            if language == "pt" {
                titleAC = methodObject.name_pt
                aboutTextAC = methodObject.about_pt.replacingOccurrences(of: "\\n", with: "\n")
                howToAC = methodObject.howToApply_pt.replacingOccurrences(of: "\\n", with: "\n")
                aboutTitleAC = "Sobre"
                howToApplyTitleAC = "Como Aplicar"
               
            } else {
                titleAC = methodObject.name_en
                aboutTextAC = methodObject.about_en.replacingOccurrences(of: "\\n", with: "\n")
                howToAC = methodObject.howToApply_en.replacingOccurrences(of: "\\n", with: "\n")
                aboutTitleAC = "About"
                howToApplyTitleAC = "How to Apply"
               
            }
        }
        
        let items = [titleAC," ",aboutTitleAC," ",aboutTextAC," ",howToApplyTitleAC," ",howToAC]
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
    
    private func getFavoriteUIItemButtonWith(icon: String) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: icon), style: .plain, target: self, action: #selector(self.setFavoriteMethod))
    }
}

