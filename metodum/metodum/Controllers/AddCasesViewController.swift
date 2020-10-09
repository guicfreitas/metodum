//
//  AddCasesViewController.swift
//  metodum
//
//  Created by Radija Praia on 26/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit


class AddCasesViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet weak var pickerPicture: UIImageView!
    @IBOutlet weak var TtitleCase: UITextField!
    @IBOutlet weak var instituteName: UITextField!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var descriptionAboutCase: UITextView!
    @IBOutlet weak var descriptionResultCase: UITextView!
    @IBOutlet weak var buttonPickerPicture: UIButton!
    
    @IBAction func cancelCase(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addCase(_ sender: UIBarButtonItem) {
        if let image = pickerPicture.image, let title = TtitleCase.text, let institute = instituteName.text, let location = locationName.text, let description = descriptionAboutCase.text, let result = descriptionResultCase.text {
            
            var imgName = title.replacingOccurrences(of: " ", with: "_")
            imgName.append(".png")
            
            let newCase = Case(
                uid: "",
                caseTitle: title,
                caseSubtitle: institute,
                caseImage: imgName,
                aboutCase: description,
                caseResult: result
            )
            self.showSpinner(onView: self.view)
            ImagesRepository.uploadCaseImage(data: image.pngData()!,imageName: newCase.caseImage) { (error) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    CasesCloudRepository.addCase(newCase: newCase) { (error) in
                        if let errorMessage = error {
                            self.alertError(message: errorMessage)
                        } else {
                            self.removeSpinner()
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Sucesso!", message: "Seu caso foi enviado para análise, aguarde o email de confirmação", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var placeholder: String = "Escreva aqui..."
    
    @IBAction func buttonPicker(_ sender: UIButton) {
        globalImagePicker.allowsEditing = false
        globalImagePicker.sourceType = .photoLibrary
        
        present(globalImagePicker, animated: true, completion: nil)
    }
    
    // Método obrigatório da UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let receiveInf = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickerPicture.contentMode = .scaleAspectFit
            
            pickerPicture.image = receiveInf
            pickerPicture.contentMode = .scaleAspectFill
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    let globalImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 15
        
        globalImagePicker.delegate = self
        super.viewDidLoad()
        
        
        descriptionAboutCase.delegate = self
        
        
        descriptionResultCase.delegate = self
        
        descriptionResultCase.attributedText = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        descriptionAboutCase.attributedText = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        descriptionResultCase.textColor = .lightGray
        descriptionAboutCase.textColor = .lightGray
        
        instituteName.setLeftPaddingPoints(15.0)
        locationName.setLeftPaddingPoints(15.0)
        
        
        
        
        aboutLabel.attributedText = NSAttributedString(string: "SOBRE", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        aboutLabel.font = .preferredFont(forTextStyle: .body)
        aboutLabel.adjustsFontForContentSizeCategory = true
        
        resultsLabel.attributedText = NSAttributedString(string: "RESULTADOS", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        resultsLabel.font = .preferredFont(forTextStyle: .body)
        resultsLabel.adjustsFontForContentSizeCategory = true
        
        pickerButton.backgroundColor = UIColor(named: "BlackBody")?.withAlphaComponent(0.6)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder{
            textView.text = ""
            textView.textColor = .gray
            //Tema dark
    //            if traitCollection.userInterfaceStyle == .dark{
    //                textView.textColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    //            } else {
    //                textView.textColor = .gray
    //
    //            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}





