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
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBOutlet weak var casesCollection: UICollectionView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CasesCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Case.caseList.count
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CasesCollectionViewCell
        
        let caseObjeto = Case.caseList[indexPath.row]
        cell.caseTitle.text = caseObjeto.cases
        cell.caseSubtitle.text = caseObjeto.caseSubtitle
        cell.setImage(named: caseObjeto.caseImage)
        cell.id = caseObjeto.id
        cell.layer.cornerRadius = 12
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsController = segue.destination as? CasesDetailViewController {
            let cell = sender as! CasesCollectionViewCell
            detailsController.id = cell.id
        }
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
        casesCollection.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
}
