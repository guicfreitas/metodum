//
//  CasesCollectionViewController.swift
//  metodum
//
//  Created by Radija Praia on 22/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit
import Foundation

class CasesCollectionViewController: UIViewController {
    
    @IBOutlet weak var casesCollection: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var cases : [Case] = []
    var persistedImagesNames = [String]()
    var language = Locale.current.languageCode

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItem.title = NSLocalizedString("cases", comment: "")
        
        self.showSpinner(onView: self.view)
        CasesCloudRepository.getAllCases { (error, cases) in
            self.removeSpinner()
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            } else {
                if let newCases = cases {
                    self.cases = newCases
                    self.persistedImagesNames = DeviceDataPersistenceService.getAllPersistedImagesNames(from: .casesImages)
                    self.casesCollection.reloadData()
                }
            }
        }
        //self.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = AuthService.getUser() {
            print("ta adicionando")
            navItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCaseScreen))
            ]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CaseDetailsSegue" {
            if let detailsController = segue.destination as? CasesDetailViewController {
                let selectedCase = sender as! Case
                detailsController.selectedCase = selectedCase
            }
        }
    }
    
    @objc func addCaseScreen() {
        performSegue(withIdentifier: "Add Case Screen", sender: nil)
    }
}

extension CasesCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cases.count
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CasesCollectionViewCell
        
        let caseObjeto = cases[indexPath.item]
        cell.caseTitle.text = (language == "pt") ? caseObjeto.title_pt : caseObjeto.title_en
        cell.caseSubtitle.text = (language == "pt") ? caseObjeto.subtitle_pt : caseObjeto.subtitle_en
        
        cell.layer.cornerRadius = 12
        
        if persistedImagesNames.contains(caseObjeto.image) {
            if let acessibilityImage = DeviceDataPersistenceService.getImage(named: caseObjeto.image, on: .casesImages) {
                cell.caseImage.image = UIImage(data: acessibilityImage.data)
            }
        } else {
            ImagesRepository.getCase(image: caseObjeto.image) { (error, acessibilityImage) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    DeviceDataPersistenceService.write(acessibilityImage: acessibilityImage!, named: caseObjeto.image, on: .casesImages)
                    cell.caseImage.image = UIImage(data: acessibilityImage!.data)
                }
            }
        }
        
        //VOICE OVER
        cell.caseTitle.isAccessibilityElement = true
        cell.caseTitle.accessibilityLabel = (language == "pt") ? caseObjeto.title_pt : caseObjeto.title_en
        cell.caseTitle.accessibilityHint = "Título indicando o nome do caso de sucesso"
        
        cell.caseSubtitle.isAccessibilityElement = true
        cell.caseSubtitle.accessibilityLabel = (language == "pt") ? caseObjeto.subtitle_pt : caseObjeto.subtitle_en
        cell.caseSubtitle.accessibilityHint = "Título indicando o local do caso de sucesso"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CaseDetailsSegue", sender: cases[indexPath.item])
    }
}

extension CasesCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullHeight = collectionView.frame.height
        let fullWidth = collectionView.frame.width
        var cellFixedHeight : CGFloat = 0
        
        if fullHeight > 900 {
            cellFixedHeight = 220
        } else {
            cellFixedHeight = 160
        }
        
        let numberOfLinesOnScreen = fullHeight / cellFixedHeight
        let itemHeight = (fullHeight / numberOfLinesOnScreen) - (5*2)
        let itemWidth = fullWidth - (20 * 2)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //funçao que calcula o tamanha celula (faz zerar o valor)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let collection = casesCollection {
            collection.collectionViewLayout.invalidateLayout()
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}
