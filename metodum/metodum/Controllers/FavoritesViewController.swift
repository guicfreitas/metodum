//
//  FavoritesViewController.swift
//  metodum
//
//  Created by João Guilherme on 07/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController{
    
    
    @IBOutlet weak var heightFavoriteCollection: NSLayoutConstraint!
    @IBOutlet weak var heightCaseCollection: NSLayoutConstraint!
    @IBOutlet weak var navigationIten: UINavigationItem!
    @IBOutlet weak var favoriteCollection: UICollectionView!
    @IBOutlet weak var favoriteCasesCollection: UICollectionView!
    
    var methods = [Methodology]()
    var cases = [Case]()
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCollection.delegate = self
        favoriteCasesCollection.delegate = self
        favoriteCollection.dataSource = self
        favoriteCasesCollection.dataSource = self
        
//        favoriteCollection.register(FavoriteMethods.self, forCellWithReuseIdentifier: "FavoriteMethods")
//        favoriteCasesCollection.register(FavoriteCases.self, forCellWithReuseIdentifier: "favoriteCases")
        
        let parent = self.parent as! ViewController
        user = parent.user
        setNavigationBar()
        if(self.view.frame.height < 800) {
            heightCaseCollection.constant = 138
            heightFavoriteCollection.constant = 138
        }else{
            heightCaseCollection.constant = 200
            heightFavoriteCollection.constant = 200
        }
//        TeachersCloudRepository.getFavoriteMethodsUidsForTeacher(teacherUid: user!.uid) { (error, documentsUids) in
//            if let errorMessage = error {
//                self.alertError(message: errorMessage)
//            } else {
//                print("methods uids")
//                print(documentsUids as Any)
//                MethodsCloudRepository.query(methodsUids: documentsUids!, language: "pt") { (error, favoriteMethods) in
//                    if let errorMessage = error {
//                        self.alertError(message: errorMessage)
//                    } else {
//                        print("metodos preferidos")
//                        print(favoriteMethods as Any)
//                        DispatchQueue.main.async {
//                            if let m = favoriteMethods {
//                                self.methods = m
//                            } else {
//                                self.methods = []
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        TeachersCloudRepository.getFavoriteCasesUidsForTeacher(teacherUid: user!.uid) { (error, documentsUids) in
//            if let errorMessage = error {
//                self.alertError(message: errorMessage)
//            } else {
//                print("cases uids")
//                print(documentsUids as Any)
//                CasesCloudRepository.query(casesUids: documentsUids!, language: "pt") { (error, favoriteCases) in
//                    if let errorMessage = error {
//                        self.alertError(message: errorMessage)
//                    } else {
//                        print("cases preferidos")
//                        print(favoriteCases as Any)
//                        DispatchQueue.main.async {
//                            if let c = favoriteCases {
//                                self.cases = c
//                            } else {
//                                self.cases = []
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func setNavigationBar() {
        self.navigationIten.title = "Favoritos"
        self.navigationIten.largeTitleDisplayMode = .always
        
        self.navigationIten.rightBarButtonItems = [
            UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut)),
        ]
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

extension FavoritesViewController: UICollectionViewDelegate{
    

    
}

extension FavoritesViewController: UICollectionViewDataSource{
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMethods", for: indexPath) as! FavoriteMethods
//
//        cell.layer.cornerRadius = 20
//        cell.backgroundColor = UIColor.red
        
        
        if(collectionView == favoriteCasesCollection){
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "favCase", for: indexPath) as! FavoriteCasesCell

            cell2.layer.cornerRadius = 20
            cell2.backgroundColor = UIColor.blue

            return cell2
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favMethod", for: indexPath) as! FavoriteMethodCell
        
                    cell.layer.cornerRadius = 20
                    cell.backgroundColor = UIColor.red
            return cell
        }
        
        //return cell

    }
        
    
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 1.55
//            if(collectionView == favoriteCasesCollection){
//                let height2 = collectionView.frame.height
//                let width2 = height * 1.55
//                
//                return CGSize(width: width2, height: height2)
//                
//            }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if(collectionView == favoriteCollection){
            return 20
        }else{
            return 20
        }
    
    }

}
