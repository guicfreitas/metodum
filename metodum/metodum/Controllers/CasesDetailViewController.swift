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

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupNavigationBar()
        
        if let caseObject = selectedCase {
            self.title = caseObject.caseTitle
            self.aboutText.text = caseObject.aboutCase
            self.resultText.text = caseObject.caseResult
            
            picture.image = UIImage(named: caseObject.caseImage)
            
            //VOICE OVER
            
            self.aboutText.isAccessibilityElement = true
            self.aboutText.accessibilityLabel = caseObject.aboutCase
            
            self.resultText.isAccessibilityElement = true
            self.resultText.accessibilityLabel = caseObject.aboutCase
            
            //necesarrio descrever imagem para o voice over
            self.picture.isAccessibilityElement = true
            self.picture.accessibilityLabel = caseObject.caseImage
            self.picture.accessibilityHint = caseObject.caseImage
            
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
        
        let addFavoriteCase = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(setFavoriteCase))
        
        let pdfConversionButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(convertCaseToPdf))
        
        addFavoriteCase.tintColor = .systemOrange
        pdfConversionButton.tintColor = .systemOrange
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButtonItems([pdfConversionButton,addFavoriteCase], animated: false)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    @objc private func setFavoriteCase() {
            let user = AuthService.getUser()
            if let teacher = user, let caseObj = selectedCase {
                TeachersCloudRepository.addCaseForTeacher(teacherUid: teacher.uid, favoriteCase: caseObj)
            }
    }
    
  @objc private func convertCaseToPdf(_ sender: UIBarButtonItem) {
        // createPrintFormatter(index: self.id)
        // openQlPreview()
        let customItem = SharePDFActivity(title: "Export PDF", image: UIImage(named: "doc.text")) { sharedItems in
            if let caseObject = self.selectedCase {
                createPrintFormatter(selectedCase: caseObject)
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
