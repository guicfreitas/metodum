//
//  PoliticsViewController.swift
//  metodum
//
//  Created by João Guilherme on 26/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class PoliticsViewController: UIViewController {
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var privButton: UIButton!
    let language = Locale.current.languageCode
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    var attrs = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .semibold),
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    
    var attributedStringTerms = NSMutableAttributedString(string:"")
    var attributedStringPriv = NSMutableAttributedString(string:"")
    
    var callback : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonTitleTerms = NSMutableAttributedString(string:(language == "pt") ? "termos de uso" : "terms of use", attributes:attrs)
        let buttonTitlePriv = NSMutableAttributedString(string: (language == "pt") ? "política de privacidade" : "privacy policy", attributes:attrs)
        attributedStringTerms.append(buttonTitleTerms)
        attributedStringPriv.append(buttonTitlePriv)
        
        termsButton.setAttributedTitle(attributedStringTerms, for: .normal)
        privButton.setAttributedTitle(attributedStringPriv, for: .normal)
        acceptButton.layer.cornerRadius = 10
        
        if traitCollection.userInterfaceStyle == .light{
            label1.textColor = .white
            label2.textColor = .white
            label3.textColor = .white
            label4.textColor = .white
        }
    }
    
    @IBAction func acceptedButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
        callback?()
    }
    
    
    @IBAction func termsPressed(_ sender: Any){
        performSegue(withIdentifier: "terms", sender: nil)
        
    }
    
    @IBAction func privPressed(_ senedr: Any){
        performSegue(withIdentifier: "priv", sender: nil)
        
    }
}

