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
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
        
        
        if let methodObject = selectedMethod {
            navigationItem.title = methodObject.name
            
            self.about.text = methodObject.description
            self.howToApply.text = methodObject.description
//            self.image.image = UIImage(named: methodObject.methodImage)
            DispatchQueue.main.async {
                ImagesRepository.getMethod(image: methodObject.methodImage) { (error, acessibilityImage) in
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
        navigationController?.isNavigationBarHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
