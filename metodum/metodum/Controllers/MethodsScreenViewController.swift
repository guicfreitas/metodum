//  MethodsScreenViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emAltaImage: UIImageView!
    @IBOutlet weak var emAltaLabel: UILabel!
    @IBOutlet weak var maisSugesLabel: UILabel!
    
   
    
}

class MethodsScreenViewController: UIViewController {
    
    let edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    var methods = [Methodology]()
    var trendMethod : Methodology?
    var headerHeight : CGFloat = 300
    
    @IBOutlet weak var maisSugesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maisSugesCollection.delegate = self
        maisSugesCollection.dataSource = self
        
        DispatchQueue.main.async {
            
            MethodsCloudRepository.getAllMethods(language: "pt") { (error, methods) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    if let m = methods {
                        self.methods = m
                        self.trendMethod = self.methods.remove(at: 0)
                        //print("is main Thread ? \(Thread.isMainThread)")
                        //print(self.trendMethod!)
                        //print(self.methods)
                        self.maisSugesCollection.reloadData()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MethodScreenViewSegue" {
            if let details = segue.destination as? MethodDetailViewController {
                let salectedMethod = sender as! Methodology
                details.selectedMethod = salectedMethod
            }
        }
    }
    
}

func heigthForHeader(labelA : UILabel, labelB : UILabel, image : UIImageView) -> CGFloat{
    let height = labelA.frame.height + labelB.frame.height + image.frame.height + 80

    return height

}



extension MethodsScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MethodsCloudRepository.incrementClicksCountFor(methodology: &methods[indexPath.item], language: "pt")
        performSegue(withIdentifier: "MethodScreenViewSegue", sender: methods[indexPath.item])
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollection", for: indexPath) as!CollectionHeader
//                // Layout to get the right dimensions
//                headerView.layoutIfNeeded()
//
//                // Automagically get the right height
//                let height = headerView.contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
//
//                // return the correct size
//                return CGSize(width: collectionView.frame.width, height: height)
//
//    }
}

extension MethodsScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return methods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "methodCell", for: indexPath) as! MethodCell
       
        cell.layer.cornerRadius = 20
        cell.backgroundColor = UIColor.red
        let imageview:UIImageView = UIImageView(frame: CGRect(x:0, y:0,width: cell.frame.width, height: cell.frame.height))
        
        cell.contentView.addSubview(imageview)
        
        let method = methods[indexPath.item]
        
        DispatchQueue.main.async {
            ImagesRepository.getMethod(image: method.methodImage) { (error, acessibilityImage) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    if let image = acessibilityImage {
                        imageview.image = UIImage(data: image.data)
                        //print("is main Thread ? \(Thread.isMainThread)")
                        //VOICE OVER
                        cell.isAccessibilityElement = true
                        cell.accessibilityLabel = image.acessibilityLabel //nome da figura
                        cell.accessibilityHint = image.acessibilityHint //dica para a figura
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollection", for: indexPath) as!CollectionHeader
        
        DispatchQueue.main.async {
            if let method = self.trendMethod {
                ImagesRepository.getMethod(image: method.methodImage) { (error, acessibilityImage) in
                    print("is main thread ? \(Thread.isMainThread)")
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        if let image = acessibilityImage {
                            headerView.emAltaImage.image = UIImage(data: image.data)
                            print(image)
                            headerView.emAltaImage.isAccessibilityElement = true
                            headerView.emAltaImage.accessibilityLabel = image.acessibilityLabel
                            headerView.emAltaImage.accessibilityHint = image.acessibilityHint
                        }
                    }
                }
            }
        }
        headerView.emAltaImage.layer.cornerRadius = 20
        headerHeight = heigthForHeader(labelA: headerView.emAltaLabel, labelB: headerView.maisSugesLabel, image: headerView.emAltaImage)
        
        
        
        return headerView
    }
    
    
}

extension MethodsScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullWidth = collectionView.frame.width
        
        let itemWidth = (fullWidth / 2) - (edgeInsets.left + 10)
        let itemHeight = itemWidth
        print(itemHeight)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print(headerHeight)
        return CGSize(width: maisSugesCollection.frame.width, height: headerHeight)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                headerHeight += 250
                
            } else {
                print("Portrait")
                headerHeight -= 140
            }
        
       // headerHeight += 100
    }
    
    
    
    
    
}
