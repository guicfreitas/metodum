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
    var persistedImagesNames : [String] = []
    var methods = [Methodology]()
    var trendMethod : Methodology?
    var headerHeight : CGFloat = 300
    var user : User?
    
    @IBOutlet weak var maisSugesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maisSugesCollection.delegate = self
        maisSugesCollection.dataSource = self
        let parentController = self.parent as! ViewController
        user = parentController.user
        self.showSpinner(onView: self.view)
        
        MethodsCloudRepository.getAllMethods() { (error, methods) in
            self.removeSpinner()
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            } else {
                if let m = methods, !m.isEmpty {
                    self.methods = m
                    self.trendMethod = self.methods.remove(at: 0)
                    //print("is main Thread ? \(Thread.isMainThread)")
                    self.persistedImagesNames = DeviceDataPersistenceService.getAllPersistedImagesNames(from: .methodsImages)
                    print("persisted images names")
                    print(self.persistedImagesNames)
                    self.maisSugesCollection.reloadData()
                }
            }
        }
    }
    
    @IBAction func trendingMethodTapped(_ sender: Any) {
        print("em alta clicado")
        performSegue(withIdentifier: "MethodScreenViewSegue", sender: trendMethod)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MethodScreenViewSegue" {
            if let details = segue.destination as? MethodDetailViewController {
                let salectedMethod = sender as! Methodology
                details.selectedMethod = salectedMethod
                details.user = user
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
        MethodsCloudRepository.incrementClicksCountFor(methodology: &methods[indexPath.item])
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
        
        if persistedImagesNames.contains(method.methodSquareImage) {
            if let image = DeviceDataPersistenceService.getImage(named: method.methodSquareImage, on: .methodsImages) {
                print("persisted image")
                print(image)
                imageview.image = UIImage(data: image.data)
                //print("is main Thread ? \(Thread.isMainThread)")
                //VOICE OVER
                cell.isAccessibilityElement = true
                cell.accessibilityLabel = image.acessibilityLabel //nome da figura
                cell.accessibilityHint = image.acessibilityHint
            }
        } else {
            ImagesRepository.getMethod(image: method.methodSquareImage) { (error, acessibilityImage) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    if let image = acessibilityImage {
                        DeviceDataPersistenceService.write(acessibilityImage: image, named: method.methodSquareImage, on: .methodsImages)
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
        
        if let method = self.trendMethod {
            if persistedImagesNames.contains(method.methodFullImage) {
                if let image = DeviceDataPersistenceService.getImage(named: method.methodFullImage, on: .methodsImages) {
                    print("persisted trending image")
                    print(image)
                    headerView.emAltaImage.image = UIImage(data: image.data)
                    //print(image)
                    headerView.emAltaImage.isAccessibilityElement = true
                    headerView.emAltaImage.accessibilityLabel = image.acessibilityLabel
                    headerView.emAltaImage.accessibilityHint = image.acessibilityHint
                }
            } else {
                ImagesRepository.getMethod(image: method.methodFullImage) { (error, acessibilityImage) in
                    print("entrou no repo de imagens")
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        if let image = acessibilityImage {
                            DeviceDataPersistenceService.write(acessibilityImage: image, named: method.methodFullImage, on: .methodsImages)
                            headerView.emAltaImage.image = UIImage(data: image.data)
                            //print(image)
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
        //print(itemHeight)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //print(headerHeight)
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
