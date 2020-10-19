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
    
    var language = Locale.current.languageCode!
    
    var methods = [Methodology]()
    var persistedMethodsImagesNames = [String]()
    var persistedCasesImagesNames = [String]()
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
        self.showSpinner(onView: self.view)

        guard let curretnUser = user else {return}
        
        self.persistedMethodsImagesNames = DeviceDataPersistenceService.getAllPersistedImagesNames(from: .methodsImages)
        self.persistedCasesImagesNames = DeviceDataPersistenceService.getAllPersistedImagesNames(from: .casesImages)

        TeachersCloudRepository.getFavoriteMethodsUidsForTeacher(teacherUid: curretnUser.uid) { (error, documentsUids) in
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            } else {
                if let uids = documentsUids {
                    if uids.isEmpty {
                        DispatchQueue.main.async {
                            self.methods = []
                            self.favoriteCollection.reloadData()
                        }
                    } else {
                        MethodsCloudRepository.query(methodsUids: uids) { (error, favoriteMethods) in
                            if let errorMessage = error {
                                self.alertError(message: errorMessage)
                            } else {
                                if let m = favoriteMethods {
                                    self.methods = m
                                    self.favoriteCollection.reloadData()
                                }
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
                if let uids = documentsUids {
                    self.removeSpinner()
                    if uids.isEmpty {
                        DispatchQueue.main.async {
                            self.cases = []
                            self.favoriteCasesCollection.reloadData()
                        }
                    } else {
                        CasesCloudRepository.query(casesUids: uids) { (error, favoriteCases) in
                            if let errorMessage = error {
                                self.alertError(message: errorMessage)
                            } else {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CaseDetailsSegue" {
            if let detailsController = segue.destination as? CasesDetailViewController {
                let selectedCase = sender as! Case
                detailsController.selectedCase = selectedCase
                detailsController.user = user
            }
        } else if segue.identifier == "MethodScreenViewSegue" {
            if let details = segue.destination as? MethodDetailViewController {
                let salectedMethod = sender as! Methodology
                details.selectedMethod = salectedMethod
                details.user = user
            }
        }
    }
    
    private func setNavigationBar() {
        let logOutLabel = NSLocalizedString("sign", comment: "")
        self.navigationIten.title = NSLocalizedString("fav", comment: "")
        self.navigationIten.largeTitleDisplayMode = .always
        
        self.navigationIten.rightBarButtonItems = [
            UIBarButtonItem(title: logOutLabel, style: .plain, target: self, action: #selector(signOut)),
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
        return (collectionView.tag == 1) ? cases.count : methods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            performSegue(withIdentifier: "CaseDetailsSegue", sender: cases[indexPath.item])
        } else {
            performSegue(withIdentifier: "MethodScreenViewSegue", sender: methods[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMethods", for: indexPath) as! FavoriteMethods
//
//        cell.layer.cornerRadius = 20
//        cell.backgroundColor = UIColor.red
        
        
        if (collectionView.tag == 1) {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "favCase", for: indexPath) as! FavoriteCasesCell
            let actualCase = cases[indexPath.item]
            
            if persistedCasesImagesNames.contains(actualCase.image) {
                if let image = DeviceDataPersistenceService.getImage(named: actualCase.image, on: .casesImages) {
                    cell2.setImage(image: image)
                    cell2.isAccessibilityElement = true
                    cell2.accessibilityLabel = (self.language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
                    cell2.accessibilityHint = (self.language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
                }
            } else {
                ImagesRepository.getCase(image: actualCase.image) { (error, acessibilityImage) in
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        guard let img = acessibilityImage else {return}
                        cell2.setImage(image: img)
                        cell2.isAccessibilityElement = true
                        cell2.accessibilityLabel = (self.language == "pt") ? img.acessibilityLabel_pt : img.acessibilityLabel_en
                        cell2.accessibilityHint = (self.language == "pt") ? img.acessibilityHint_pt : img.acessibilityHint_en
                    }
                }
            }

            cell2.layer.cornerRadius = 20

            return cell2
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favMethod", for: indexPath) as! FavoriteMethodCell
            let method = methods[indexPath.item]
            // hj eu mudo essa merda pra cachear as imagens, eu juro
            
            if persistedMethodsImagesNames.contains(method.methodFullImage) {
                if let image = DeviceDataPersistenceService.getImage(named: method.methodFullImage, on: .methodsImages) {
                    cell.setImage(image: image)
                    cell.isAccessibilityElement = true
                    cell.accessibilityLabel = (self.language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
                    cell.accessibilityHint = (self.language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
                }
            } else {
                ImagesRepository.getMethod(image: method.methodFullImage) { (error, acessibilityImage) in
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        guard let img = acessibilityImage else {return}
                        cell.setImage(image: img)
                        cell.isAccessibilityElement = true
                        cell.accessibilityLabel = (self.language == "pt") ? img.acessibilityLabel_pt : img.acessibilityLabel_en
                        cell.accessibilityHint = (self.language == "pt") ? img.acessibilityHint_pt : img.acessibilityHint_en
                    }
                }
            }
            cell.layer.cornerRadius = 20
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
        return 20
    }
}
