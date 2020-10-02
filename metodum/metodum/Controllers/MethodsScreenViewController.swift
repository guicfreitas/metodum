//
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
    
}

class MethodsScreenViewController: UIViewController {
    
    let edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    var methods = [Methodology]()
    var trendMethod : Methodology?
    
    @IBOutlet weak var maisSugesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maisSugesCollection.delegate = self
        maisSugesCollection.dataSource = self
        
        MethodsCloudRepository.getAllMethods(language: "pt") { (error, methods) in
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            } else {
                if let m = methods {
                    self.methods = m
                    self.trendMethod = self.methods.remove(at: 0)
                    
                    print(self.trendMethod!)
                    print(self.methods)
                    self.maisSugesCollection.reloadData()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
}

extension MethodsScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        //print(methods[indexPath.item])
        MethodsCloudRepository.incrementClicksCountFor(methodology: &methods[indexPath.item], language: "pt")
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
        
        imageview.image = UIImage(named: "cbl")
        cell.contentView.addSubview(imageview)
        
        let method = methods[indexPath.item]
        
        DispatchQueue.main.async {
            ImagesRepository.getMethod(image: method.methodImage) { (error, acessibilityImage) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    if let image = acessibilityImage {
                        imageview.image = UIImage(data: image.data)
                        //VOICE OVER
                        cell.isAccessibilityElement = true
                        cell.accessibilityLabel = image.acessibilityLabel //nome da figura
                        cell.accessibilityHint = image.acessibilityHint //dica para a figura
                    }
                }
            }
        }
        
        print("foi2")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollection", for: indexPath) as!CollectionHeader
        
        DispatchQueue.main.async {
            ImagesRepository.getMethod(image: self.trendMethod?.methodImage ?? "trend.jpg") { (error, acessibilityImage) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    if let image = acessibilityImage {
                        headerView.emAltaImage.image = UIImage(data: image.data)
                        //VOICE OVER
                        print(image)
                        headerView.emAltaImage.isAccessibilityElement = true
                        headerView.emAltaImage.accessibilityLabel = image.acessibilityLabel //nome da figura
                        headerView.emAltaImage.accessibilityHint = image.acessibilityHint  //dica para a figura
                    }
                }
            }
        }
        
        headerView.emAltaImage.layer.cornerRadius = 20
        
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
    
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height*0.59)
    }
}
