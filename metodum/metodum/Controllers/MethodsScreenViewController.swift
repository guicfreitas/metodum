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
    var language = ""
    var firstTime = true
    
    @IBOutlet weak var maisSugesCollection: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        maisSugesCollection.delegate = self
        maisSugesCollection.dataSource = self
       
        self.showSpinner(onView: self.view)
        language = Locale.current.languageCode!
        
        MethodsCloudRepository.getAllMethods() { (error, methods) in
            self.removeSpinner()
            if let errorMessage = error {
                self.alertError(message: errorMessage)
            } else {
                if let m = methods, !m.isEmpty {
                    self.methods = m
                    self.trendMethod = self.methods.remove(at: 0)
                    self.persistedImagesNames = DeviceDataPersistenceService.getAllPersistedImagesNames(from: .methodsImages)
                    self.maisSugesCollection.reloadData()
                    self.firstTime = false
                }
            }
        }
    }
    
    @IBAction func trendingMethodTapped(_ sender: Any) {
        performSegue(withIdentifier: "MethodScreenViewSegue", sender: trendMethod)
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
        var labelText = ""
        var textsSplit = [""]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "methodCell", for: indexPath) as! MethodCell
       
        cell.layer.cornerRadius = 20
        cell.backgroundColor = UIColor.red
        let imageview:UIImageView = UIImageView(frame: CGRect(x:0, y:0,width: cell.frame.width, height: cell.frame.height))
        
        cell.contentView.addSubview(imageview)
        
        let method = methods[indexPath.item]
        
        if persistedImagesNames.contains(method.methodSquareImage) {
            if let image = DeviceDataPersistenceService.getImage(named: method.methodSquareImage, on: .methodsImages) {
                imageview.image = UIImage(data: image.data)
                cell.isAccessibilityElement = true
                cell.accessibilityLabel = (language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
                cell.accessibilityHint = (language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
                labelText = (self.language == "pt") ? method.name_pt : method.name_en
                print("ISSO TA NO VETOR: ",labelText)
                textsSplit = labelText.components(separatedBy: " ")
            }
            let heightMask = imageview.frame.height * 0.25821596
            let mask = UIView(frame: CGRect(x: 0, y: (cell.frame.height)-heightMask, width: cell.frame.width, height: heightMask+2))
            mask.backgroundColor = UIColor(named: "MethodLabel")
            
            
            print("Vetor de texto:",textsSplit)
            
                
                let labelMenor = UILabel(frame: CGRect(x: 15, y: 10, width: cell.frame.width - 30, height: 12))
                labelMenor.textColor = UIColor.white
                labelMenor.text = textsSplit[0].uppercased()
                labelMenor.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
                
                let labelMaior = UILabel(frame: CGRect(x: 15, y: 20, width: cell.frame.width - 30, height: 21))
                labelMaior.textColor = UIColor.white
                textsSplit.remove(at: 0)
                
                labelMaior.text = textsSplit.joined(separator: " ")
                labelMaior.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
                
                labelMaior.textColor = UIColor(named: "TextLabel")
                labelMenor.textColor = UIColor(named: "TextLabel")
                
                mask.addSubview(labelMenor)
                mask.addSubview(labelMaior)
                            
                imageview.addSubview(mask)
                
        } else {
            ImagesRepository.getMethod(image: method.methodSquareImage) { (error, acessibilityImage) in
                if let errorMessage = error {
                    self.alertError(message: errorMessage)
                } else {
                    if let image = acessibilityImage {
                        DeviceDataPersistenceService.write(acessibilityImage: image, named: method.methodSquareImage, on: .methodsImages)
                        imageview.image = UIImage(data: image.data)

                        cell.isAccessibilityElement = true
                        cell.accessibilityLabel = (self.language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
                        cell.accessibilityHint = (self.language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
                        labelText = (self.language == "pt") ? method.name_pt : method.name_en
                        print("ISSO TA NO VETOR: ",labelText)
                        textsSplit = labelText.components(separatedBy: " ")
                    }
                    let heightMask = imageview.frame.height * 0.25821596
                    let mask = UIView(frame: CGRect(x: 0, y: (cell.frame.height)-heightMask, width: cell.frame.width, height: heightMask+2))
                    mask.backgroundColor = UIColor(named: "MethodLabel")
                    
                    
                    print("Vetor de texto:",textsSplit)
                    
                        
                        let labelMenor = UILabel(frame: CGRect(x: 15, y: 10, width: cell.frame.width - 30, height: 12))
                        labelMenor.textColor = UIColor.white
                        labelMenor.text = textsSplit[0].uppercased()
                        labelMenor.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
                        
                        let labelMaior = UILabel(frame: CGRect(x: 15, y: 20, width: cell.frame.width - 30, height: 21))
                        labelMaior.textColor = UIColor.white
                        textsSplit.remove(at: 0)
                        
                        labelMaior.text = textsSplit.joined(separator: " ")
                        labelMaior.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
                        
                        labelMaior.textColor = UIColor(named: "TextLabel")
                        labelMenor.textColor = UIColor(named: "TextLabel")
                        
                        mask.addSubview(labelMenor)
                        mask.addSubview(labelMaior)
                                    
                        imageview.addSubview(mask)
                        
                }
            }
        }
        let heightMask = imageview.frame.height * 0.25821596
        let mask = UIView(frame: CGRect(x: 0, y: (cell.frame.height)-heightMask, width: cell.frame.width, height: heightMask+2))
        mask.backgroundColor = UIColor(named: "MethodLabel")
        
        
        print("Vetor de texto:",textsSplit)
        
            
            
            
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollection", for: indexPath) as!CollectionHeader
        
        var labelText = ""
        
        if let method = self.trendMethod {
            if persistedImagesNames.contains(method.methodFullImage) {
                if let image = DeviceDataPersistenceService.getImage(named: method.methodFullImage, on: .methodsImages) {
                    headerView.emAltaImage.image = UIImage(data: image.data)
                    headerView.emAltaImage.isAccessibilityElement = true
                    headerView.emAltaImage.accessibilityLabel = (self.language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
                    headerView.emAltaImage.accessibilityHint = (self.language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
                    labelText = (self.language == "pt") ? method.name_pt : method.name_en
                }
                let heightMask = headerView.emAltaImage.frame.height * 0.25821596
                let mask = UIView(frame: CGRect(x: 0, y: ((headerView.emAltaImage.frame.height) - (heightMask))+4 , width: collectionView.frame.width-40, height: heightMask+2))
                mask.backgroundColor = UIColor(named: "MethodLabel")
                var textsSplit = labelText.components(separatedBy: " ")
                
               
                    
                    let labelMenor = UILabel(frame: CGRect(x: 15, y: 10, width: collectionView.frame.width-70, height: 12))
                    labelMenor.textColor = UIColor.white
                    labelMenor.text = textsSplit[0].uppercased()
                    labelMenor.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
                    
                    let labelMaior = UILabel(frame: CGRect(x: 15, y: 23, width: collectionView.frame.width-70, height: 27))
                    labelMaior.textColor = UIColor.white
                    textsSplit.remove(at: 0)
                    
                    labelMaior.text = textsSplit.joined(separator: " ")
                    labelMaior.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
                    
                    labelMaior.textColor = UIColor(named: "TextLabel")
                    labelMenor.textColor = UIColor(named: "TextLabel")
                    
                    mask.addSubview(labelMenor)
                    mask.addSubview(labelMaior)
                                
                    headerView.emAltaImage.addSubview(mask)
            } else {
                ImagesRepository.getMethod(image: method.methodFullImage) { (error, acessibilityImage) in
                    if let errorMessage = error {
                        self.alertError(message: errorMessage)
                    } else {
                        if let image = acessibilityImage {
                            DeviceDataPersistenceService.write(acessibilityImage: image, named: method.methodFullImage, on: .methodsImages)
                            headerView.emAltaImage.image = UIImage(data: image.data)
                            headerView.emAltaImage.isAccessibilityElement = true
                            headerView.emAltaImage.accessibilityLabel = (self.language == "pt") ? image.acessibilityLabel_pt : image.acessibilityLabel_en
                            headerView.emAltaImage.accessibilityHint = (self.language == "pt") ? image.acessibilityHint_pt : image.acessibilityHint_en
                            labelText = (self.language == "pt") ? method.name_pt : method.name_en
                        }
                        let heightMask = headerView.emAltaImage.frame.height * 0.25821596
                        let mask = UIView(frame: CGRect(x: 0, y: ((headerView.emAltaImage.frame.height) - (heightMask))+4 , width: collectionView.frame.width-40, height: heightMask+2))
                        mask.backgroundColor = UIColor(named: "MethodLabel")
                        var textsSplit = labelText.components(separatedBy: " ")
                        
                       
                            
                            let labelMenor = UILabel(frame: CGRect(x: 15, y: 10, width: collectionView.frame.width-70, height: 12))
                            labelMenor.textColor = UIColor.white
                            labelMenor.text = textsSplit[0].uppercased()
                            labelMenor.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
                            
                            let labelMaior = UILabel(frame: CGRect(x: 15, y: 23, width: collectionView.frame.width-70, height: 27))
                            labelMaior.textColor = UIColor.white
                            textsSplit.remove(at: 0)
                            
                            labelMaior.text = textsSplit.joined(separator: " ")
                            labelMaior.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
                            
                            labelMaior.textColor = UIColor(named: "TextLabel")
                            labelMenor.textColor = UIColor(named: "TextLabel")
                            
                            mask.addSubview(labelMenor)
                            mask.addSubview(labelMaior)
                                        
                            headerView.emAltaImage.addSubview(mask)
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

        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
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
    }
}
