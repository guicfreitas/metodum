//
//  AddCasesViewController.swift
//  metodum
//
//  Created by Radija Praia on 26/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class AddCasesViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var pickerPicture: UIImageView!
    @IBOutlet weak var TtitleCase: UITextField!
    @IBOutlet weak var instituteName: UITextField!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet var descriptionAboutCase: UITextView!
    @IBOutlet weak var descriptionResultCase: UITextView!
    @IBOutlet weak var buttonPickerPicture: UIButton!
    
    @IBAction func cancelCase(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addCase(_ sender: UIBarButtonItem) {
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
        globalImagePicker.delegate = self
        super.viewDidLoad()
        descriptionAboutCase.text = placeholder
        descriptionAboutCase.textColor = .lightGray
        descriptionAboutCase.delegate = self
        descriptionResultCase.text = placeholder
        descriptionResultCase.textColor = .lightGray
        descriptionResultCase.delegate = self
        
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
