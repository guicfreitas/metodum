//  ClassesScreenViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class ClassesScreenViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationIten: UINavigationItem!
    @IBOutlet weak var classesCollection: UICollectionView!
    
    var classes : [SchoolClass] = []
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        self.showSpinner(onView: self.view)
        let parent = self.parent as! ViewController
        user = parent.user
        if let loggedUser = user {
            DispatchQueue.main.async {
                TeachersCloudRepository.setTeacherClassesChangesListener(teacherId: loggedUser.uid) { (error, repoClasses) in
                    self.removeSpinner()
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        if let repoClasses = repoClasses {
                            self.classes = repoClasses
                            self.classesCollection.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func setNavigationBar() {
        self.navigationIten.title = "Turmas"
        self.navigationIten.largeTitleDisplayMode = .always
        
        self.navigationIten.rightBarButtonItems = [
            UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut)),
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(createClass))
        ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Classes Screen to Create Class Screen" {
            let user = sender as! User
            let viewController = segue.destination as! NewSchoolClassViewController
            viewController.user = user
        }
    }
    
    @objc private func signOut() {
        AuthService.signOut { (error) in
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createClass() {
        performSegue(withIdentifier: "Classes Screen to Create Class Screen", sender: self.user)
    }
}

extension ClassesScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Class Cell", for: indexPath) as! ClassesCollectionViewCell
        
        cell.setCellData(schoolClass: classes[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension ClassesScreenViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullHeight = collectionView.frame.height
        let fullWidth = collectionView.frame.width
        var cellFixedHeight : CGFloat = 0
        
        if fullHeight > 900 {
            cellFixedHeight = 220
        } else {
            cellFixedHeight = 120
        }
        
        let numberdOfLinesOnScreen = fullHeight / cellFixedHeight
        let itemHeight = (fullHeight / numberdOfLinesOnScreen ) - (5 * 2)
        let itemWidth = fullWidth - (20 * 2)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let collection = classesCollection {
            collection.collectionViewLayout.invalidateLayout()
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}
