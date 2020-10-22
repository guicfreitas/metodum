//
//  CasesDetailViewController.swift
//  metodum
//
//  Created by Radija Praia on 25/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit
import QuickLook

class CasesDetailViewController: UIViewController {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var resultText: UITextView!
    
    var selectedCase : Case?
    var user : User?
    var isFavorite = false
    var language = Locale.current.languageCode

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearNavigationBar()
        print("view did dissapear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        setupNavigationBar()
        if let currentUser = user {
            TeachersCloudRepository.getFavoriteCasesUidsForTeacher(teacherUid: currentUser.uid) { (error, favoriteCases) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    if let cases = favoriteCases {
                        DispatchQueue.main.async {
                            if cases.contains(self.selectedCase!.uid) {
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
        
        if let caseObject = selectedCase {
            self.aboutText.isAccessibilityElement = true
            self.resultText.isAccessibilityElement = true
            self.picture.isAccessibilityElement = true
            
            if language == "pt" {
                navigationItem.title = caseObject.title_pt
                self.title = caseObject.title_pt
                self.aboutText.text = caseObject.about_pt.replacingOccurrences(of: "\\n", with: "\n")
                self.resultText.text = caseObject.result_pt.replacingOccurrences(of: "\\n", with: "\n")
                self.aboutText.accessibilityLabel = caseObject.about_pt
                self.resultText.accessibilityLabel = caseObject.result_pt
                self.picture.accessibilityLabel = acessibilities[caseObject.image]?.first
                self.picture.accessibilityHint = acessibilities[caseObject.image]?.last
            } else {
                print("stou title")
                navigationItem.title = caseObject.title_en
                self.title = caseObject.title_en
                self.aboutText.text = caseObject.about_en.replacingOccurrences(of: "\\n", with: "\n")
                self.resultText.text = caseObject.result_en.replacingOccurrences(of: "\\n", with: "\n")
                self.aboutText.accessibilityLabel = caseObject.about_en
                self.resultText.accessibilityLabel = caseObject.result_en
                self.picture.accessibilityLabel = acessibilities[caseObject.image]?.first
                self.picture.accessibilityHint = acessibilities[caseObject.image]?.last
            }
            
            picture.image = UIImage(named: caseObject.image)
        }
    }
    
    private func setupNavigationBar() {
        let addFavoriteCase = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(setFavoriteCase))
        
        let pdfConversionButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(convertCaseToPdf))
        
        //addFavoriteCase.isEnabled = false
        addFavoriteCase.tintColor = .systemOrange
        pdfConversionButton.tintColor = .systemOrange
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButtonItems([pdfConversionButton,addFavoriteCase], animated: false)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    @objc private func setFavoriteCase() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        if let teacher = user, let caseObj = selectedCase {
            if isFavorite {
                TeachersCloudRepository.removeCaseForTeacher(teacherUid: teacher.uid, favoriteCaseUid: caseObj.uid) { (error) in
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    }
                }
                self.navigationItem.rightBarButtonItems![1] = self.getFavoriteUIItemButtonWith(icon: "star")
            } else {
                TeachersCloudRepository.addCaseForTeacher(teacherUid: teacher.uid, favoriteCase: caseObj) { (error) in
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    }
                }
                self.navigationItem.rightBarButtonItems![1] = self.getFavoriteUIItemButtonWith(icon: "star.fill")
            }
            isFavorite = !isFavorite
        }
    }
    
  @objc private func convertCaseToPdf(_ sender: UIBarButtonItem) {
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
    
        // createPrintFormatter(index: self.id)
        // openQlPreview()
   
    
    let customItem = SharePDFActivity(title: (self.language == "pt") ? "Exportar PDF" : "Export PDF", image: UIImage(systemName: "arrow.down.doc")) { sharedItems in
            if let caseObject = self.selectedCase {
                createPrintFormatter(selectedCase: caseObject)
            }
            self.openQlPreview()
        }
        
    var titleAC : String = ""
    var aboutTextAC : String = ""
    var resultAC : String = ""
    var aboutTitleAC : String = ""
    var resultsTitleAC : String = ""
    
    if let caseObject = selectedCase {
        
        
        if language == "pt" {
            
            titleAC = caseObject.title_pt
            aboutTextAC = caseObject.about_pt.replacingOccurrences(of: "\\n", with: "\n")
            resultAC = caseObject.result_pt.replacingOccurrences(of: "\\n", with: "\n")
            aboutTitleAC = "Sobre"
            resultsTitleAC = "Resultados"
            
        } else {
            
            titleAC = caseObject.title_en
            aboutTextAC = caseObject.about_en.replacingOccurrences(of: "\\n", with: "\n")
            resultAC = caseObject.result_en.replacingOccurrences(of: "\\n", with: "\n")
            aboutTitleAC = "About"
            resultsTitleAC = "Results"
            
        }
        
    }
    
        let items = [titleAC," ",aboutTitleAC," ",aboutTextAC," ",resultsTitleAC," ",resultAC]
    
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
        return UIBarButtonItem(image: UIImage(systemName: icon), style: .plain, target: self, action: #selector(self.setFavoriteCase))
    }
}

extension UIViewController : QLPreviewControllerDelegate , QLPreviewControllerDataSource{
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        //  pass your document url here
        return getPathOfPdf() as QLPreviewItem
    }
    
    public func previewController(_ controller: QLPreviewController, shouldOpen url: URL, for item: QLPreviewItem) -> Bool {
        return true
    }
}
