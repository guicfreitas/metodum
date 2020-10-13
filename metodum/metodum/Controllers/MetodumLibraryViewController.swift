//
//  MetodumLibraryViewController.swift
//  metodum
//
//  Created by João Guilherme on 09/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class MetodumLibraryViewController: UIViewController {
    
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var libraryCollection: UICollectionView!
    
    let imageArray = ["cases_blue","cases_orange","cases_purple","cases_yellow","cases_white","cases_grey"]
    var selectedImageName = ""
    var selected = false
    var selectedSymbolView : UIImageView?
    var callBack : ((String) -> ())?
    
    @IBAction func dismissLibrary(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func okButtonPressed(_ sender: Any) {
        callBack?(selectedImageName)
        self.dismiss(animated: true, completion: nil)
    }
}

extension MetodumLibraryViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let proportion: CGFloat = 1.43410
        let widthCell = ((collectionView.frame.width)/2) - 5
        let heightCell = widthCell/proportion
        
        let sizeSymbol = heightCell / 3.90
        
        if !selected {
            selectedSymbolView = UIImageView(frame: CGRect(x:widthCell - 40, y: heightCell - 40,width: sizeSymbol, height: sizeSymbol))
            
            selectedSymbolView!.image = UIImage(systemName: "checkmark.circle.fill")
            selectedSymbolView!.tintColor = UIColor(red: 0.94, green: 0.58, blue: 0.21, alpha: 1.00)
            
            let cell = collectionView.cellForItem(at: indexPath)
            
            cell?.contentView.addSubview(selectedSymbolView!)
            selectedImageName = imageArray[indexPath.item]
            okButton.isEnabled = true
            selected = true
            print(selectedImageName)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedSymbolView?.removeFromSuperview()
        selectedImageName = ""
        selected = false
        okButton.isEnabled = false
    }
}

extension MetodumLibraryViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "libraryCell", for: indexPath) as! LibraryCellCollectionViewCell
        
        let imageview:UIImageView = UIImageView(frame: CGRect(x:0, y:0,width: cell.frame.width, height: cell.frame.height))
        
        imageview.image = UIImage(named: imageArray[indexPath.row])
        cell.contentView.addSubview(imageview)
        return cell
    }
}

extension MetodumLibraryViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let proportion: CGFloat = 1.43410
        let width = ((collectionView.frame.width)/2) - 5
        let height =  width/proportion
        
        
        return CGSize(width: width, height: height)
    }
}


