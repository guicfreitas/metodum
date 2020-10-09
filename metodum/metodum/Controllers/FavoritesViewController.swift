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
    
    var language = "pt"
    
    var methods = [Methodology]()
    var cases = [Case]()
    var user : User?
    var teacher : Teacher?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parent = self.parent as! ViewController
        user = parent.user
        setNavigationBar()
        
        favoriteCollection.delegate = self
        favoriteCasesCollection.delegate = self
        favoriteCollection.dataSource = self
        favoriteCasesCollection.dataSource = self
        
//        favoriteCollection.register(FavoriteMethods.self, forCellWithReuseIdentifier: "FavoriteMethods")
//        favoriteCasesCollection.register(FavoriteCases.self, forCellWithReuseIdentifier: "favoriteCases")
        
        if(self.view.frame.height <= 700) {
            heightCaseCollection.constant = 138
            heightFavoriteCollection.constant = 138
        }else{
            heightCaseCollection.constant = 200
            heightFavoriteCollection.constant = 200
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let curretnUser = user else {return}
        
        TeachersCloudRepository.getFavoriteMethodsUidsForTeacher(teacherUid: curretnUser.uid) { (error, documentsUids) in
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            } else {
                print("methods uids")
                print(documentsUids as Any)
                if let uids = documentsUids, !uids.isEmpty {
                    MethodsCloudRepository.query(methodsUids: documentsUids!, language: self.language) { (error, favoriteMethods) in
                        if let errorMessage = error {
                            self.alertError(message: errorMessage)
                        } else {
                            print("metodos preferidos")
                            print(favoriteMethods as Any)
                            if let m = favoriteMethods {
                                self.methods = m
                                self.favoriteCollection.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        TeachersCloudRepository.getFavoriteCasesUidsForTeacher(teacherUid: curretnUser.uid) { (error, documentsUids) in
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            } else {
                print("cases uids")
                print(documentsUids as Any)
                if let uids = documentsUids, !uids.isEmpty {
                    CasesCloudRepository.query(casesUids: documentsUids!, language: self.language) { (error, favoriteCases) in
                        if let errorMessage = error {
                            self.alertError(message: errorMessage)
                        } else {
                            print("cases preferidos")
                            print(favoriteCases as Any)
                            if let c = favoriteCases {
                                self.cases = c
                                self.favoriteCasesCollection.reloadData()
                            }
                        }
                    }
                }
            }
        }
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
        return (collectionView == favoriteCollection) ? cases.count : methods.count
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
            let method = methods[indexPath.item]
            // hj eu mudo essa merda pra cachear as imagens, eu juro
            ImagesRepository.getMethod(image: method.methodImage) { (error, acessibilityImage) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    print("ta na celula")
                    guard let img = acessibilityImage else {return}
                    cell.setImage(image: img)
                    
                }
            }
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
