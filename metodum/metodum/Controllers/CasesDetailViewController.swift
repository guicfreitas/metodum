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
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        if let caseObject = selectedCase {
            self.title = caseObject.caseTitle
            self.aboutText.text = caseObject.aboutCase
            self.resultText.text = caseObject.caseResult
            
            picture.image = UIImage(named: caseObject.caseImage)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
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
