//
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
    let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        let parent = self.parent as! ViewController
        user = parent.user
        if let loggedUser = user {
            TeachersCloudRepository.setTeacherClassesChangesListener(teacherId: loggedUser.uuid) { (error, repoClasses) in
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
    
    func setNavigationBar() {
        self.navigationIten.title = "Turmas"
        self.navigationIten.largeTitleDisplayMode = .always
        
        self.navigationIten.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
    }
    
    @objc private func signOut() {
        AuthService.signOut { (error) in
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            }
        }
        
        navigationController?.popViewController(animated: true)
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
        
        let itemHeight = (fullHeight / 4.2 ) - (edgeInsets.bottom * 2)
        let itemWidth = fullWidth
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
