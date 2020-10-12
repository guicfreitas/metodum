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
    
    var cases : [Case] = []
    var persistedImagesNames = [String]()
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parentController = self.parent as! ViewController
        user = parentController.user
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CaseDetailsSegue" {
            if let detailsController = segue.destination as? CasesDetailViewController {
                let selectedCase = sender as! Case
                detailsController.selectedCase = selectedCase
                detailsController.user = user
            }
        }
    }
}

extension CasesCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cases.count
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CasesCollectionViewCell
        
        let caseObjeto = cases[indexPath.item]
        print("ta na celula")
        cell.caseTitle.text = caseObjeto.caseTitle
        cell.caseSubtitle.text = caseObjeto.caseSubtitle
        cell.layer.cornerRadius = 12
        
        if persistedImagesNames.contains(caseObjeto.caseImage) {
            print("tá salvo no cache")
            let acessibilityImage = DeviceDataPersistenceService.getImage(named: caseObjeto.caseImage, on: .casesImages)
            cell.caseImage.image = UIImage(data: acessibilityImage!.data)
        } else {
            print("indo pegar do server")
            ImagesRepository.getCase(image: caseObjeto.caseImage) { (error, acessibilityImage) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    print("pegando do servidor")
                    DeviceDataPersistenceService.write(acessibilityImage: acessibilityImage!, named: caseObjeto.caseImage, on: .casesImages)
                    cell.caseImage.image = UIImage(data: acessibilityImage!.data)
                }
            }
        }
        
        //VOICE OVER
        cell.caseTitle.isAccessibilityElement = true
        cell.caseTitle.accessibilityLabel = caseObjeto.caseTitle
        cell.caseTitle.accessibilityHint = "Título indicando o nome do caso de sucesso"
        
        cell.caseSubtitle.isAccessibilityElement = true
        cell.caseSubtitle.accessibilityLabel = caseObjeto.caseSubtitle
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
