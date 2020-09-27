//
//  NewSchoolClassViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 26/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class NewSchoolClassViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerSchoolClassButton(_ sender: Any) {
        
        guard let name = nameTextField.text else {return}
        guard let school = schoolTextField.text else {return}
        guard let description = descriptionTextView.text else {return}
        
        if !name.isEmpty && !school.isEmpty && !description.isEmpty {
            TeachersCloudRepository.addClassForTeacher(teacherUid: user!.uid, schoolClass: SchoolClass(name: name, schoolName: school, description: description))
            self.dismiss(animated: true, completion: nil)
        }
    }
}
