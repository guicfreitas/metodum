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
    //@IBOutlet weak var TtitleCase: UITextField!
    @IBOutlet weak var instituteName: UITextField!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var descriptionAboutCase: UITextView!
    @IBOutlet weak var descriptionResultCase: UITextView!
    @IBOutlet weak var buttonPickerPicture: UIButton!
    @IBOutlet weak var addCaseButton: UIBarButtonItem!
    
    let placeholder = NSLocalizedString("type", comment: "")
    var selectedImageName = "cases_grey.png"
    let globalImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexiSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexiSpace,doneButton], animated: true)
        
        descriptionAboutCase.delegate = self
        descriptionResultCase.delegate = self
        
        descriptionAboutCase.inputAccessoryView = toolBar
        descriptionResultCase.inputAccessoryView = toolBar
        instituteName.inputAccessoryView = toolBar
        locationName.inputAccessoryView = toolBar
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 15
        
        globalImagePicker.delegate = self
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
    
    @IBAction func cancelCase(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func doneClicked(){
        view.endEditing(true)
    }
    
    
    @IBAction func addCase(_ sender: UIBarButtonItem) {
        let recevidedLabel = NSLocalizedString("rec", comment: "")
        let analiseLabel = NSLocalizedString("analise", comment: "")
        if let image = pickerPicture.image, let institute = instituteName.text, let location = locationName.text, let description = descriptionAboutCase.text, let result = descriptionResultCase.text {
            
            var imgName = institute.replacingOccurrences(of: " ", with: "_")
            imgName.append(".png")
            
            let newCase = Case(
                uid: "",
                image: selectedImageName,
                title_en: institute,
                title_pt: institute,
                subtitle_en: location,
                subtitle_pt: location,
                about_en: description,
                about_pt: description,
                result_pt: result,
                result_en: result
            )
            
            self.showSpinner(onView: self.view)
            
            ImagesRepository.uploadCaseImage(data: image.pngData()!,imageName: newCase.image) { (error) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    CasesCloudRepository.addCase(newCase: newCase) { (error) in
                        if let errorMessage = error {
                            self.alertError(message: errorMessage)
                        } else {
                            self.removeSpinner()
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: recevidedLabel, message: analiseLabel, preferredStyle: .alert)
                                alert.view.tintColor = UIColor(red: 0.94, green: 0.58, blue: 0.21, alpha: 1.00)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                
                                self.present(alert, animated: true,completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
        if let institute = instituteName.text, let location = locationName.text, let description = descriptionAboutCase.text, let result = descriptionResultCase.text, !institute.isEmpty, !location.isEmpty, !description.isEmpty, !result.isEmpty, description != "Type Here", result != "Type Here" {
            addCaseButton.isEnabled = true
        } else {
            addCaseButton.isEnabled = false
        }
    }

    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    
    @IBAction func didPressActionSheet(_ sender: Any) {
       
        let lib = NSLocalizedString("lib", comment: "")
        let cancel = NSLocalizedString("cancel", comment: "")
        //let choose = NSLocalizedString("image", comment: "")
        
        let alerta = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alerta.view.tintColor = UIColor(red: 0.94, green: 0.58, blue: 0.21, alpha: 1.00)
        
        alerta.addAction(UIAlertAction(title: lib, style: .default, handler: { (button) in
            self.performSegue(withIdentifier: "LibraryMetodumViewController", sender: nil)
        }))
        
        /*alerta.addAction(UIAlertAction(title: choose, style: .default, handler: { (button) in
            self.globalImagePicker.allowsEditing = false
            self.globalImagePicker.sourceType = .photoLibrary
            
            self.present(self.globalImagePicker, animated: true, completion: nil)
        }))*/
        
//        alerta.addAction(UIAlertAction(title: "Tirar Foto", style: .default, handler: {(button) in
//            self.globalImagePicker.sourceType = .camera
//            self.present(self.globalImagePicker, animated: true, completion: nil)
//        }))
        
        alerta.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        
        present(alerta, animated: true, completion: nil)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LibraryMetodumViewController" {
            let controller = segue.destination as! MetodumLibraryViewController
            controller.callBack = { imageName in
                DispatchQueue.main.async {
                    self.pickerPicture.image = UIImage(named: imageName)
                }
            }
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
