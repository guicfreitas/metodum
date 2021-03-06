
// ImagesRepository
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 29/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import FirebaseStorage

enum ImagesFolders : String {
    case trendImages = "trendImages/"
    case methodologiesImages = "methodologiesImages/"
    case classesImages = "classesImages/"
    case casesImages = "casesImages/"
}

enum ImagesAcessibilityAtributes : String {
    case acessibilityLabel_pt
    case acessibilityHint_pt
    case acessibilityLabel_en
    case acessibilityHint_en
}

class ImagesRepository {
    static let storageRoot = Storage.storage().reference()
    
    static func getMethod(image url : String, completion: @escaping (String?, AcessibilityImage?) -> ()) {
        let folder = ImagesFolders.methodologiesImages.rawValue
        let imageRef = storageRoot.child(folder+url)
        
        imageRef.getData(maxSize: .max) { (imageData, error) in
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage,nil)
                }
            } else {
                imageRef.getMetadata { (metaData, error) in
                    if let errorMessage = error?.localizedDescription {
                        DispatchQueue.main.async {
                            completion(errorMessage,nil)
                        }
                    } else {
                        if let customMetaData = metaData?.customMetadata {
                            let image = AcessibilityImage(
                                data: imageData!,
                                acessibilityLabel_pt: customMetaData[ImagesAcessibilityAtributes.acessibilityLabel_pt.rawValue]!,
                                acessibilityLabel_en: customMetaData[ImagesAcessibilityAtributes.acessibilityLabel_en.rawValue]!,
                                acessibilityHint_pt: customMetaData[ImagesAcessibilityAtributes.acessibilityHint_pt.rawValue]!,
                                acessibilityHint_en: customMetaData[ImagesAcessibilityAtributes.acessibilityHint_en.rawValue]!
                            )
                            DispatchQueue.main.async {
                                completion(nil,image)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getCase(image url : String, completion: @escaping (String?, AcessibilityImage?) -> ()) {
        let folder = ImagesFolders.casesImages.rawValue
        let imageRef = storageRoot.child(folder+url)
        
        imageRef.getData(maxSize: .max) { (imageData, error) in
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage,nil)
                }
            } else {
                DispatchQueue.main.async {
                    let image = AcessibilityImage(
                        data: imageData!,
                        acessibilityLabel_pt: " ",
                        acessibilityLabel_en: " ",
                        acessibilityHint_pt: " ",
                        acessibilityHint_en: " "
                    )
                    completion(nil,image)
                }
                /*imageRef.getMetadata { (metaData, error) in
                    if let errorMessage = error?.localizedDescription {
                        DispatchQueue.main.async {
                            completion(errorMessage,nil)
                        }
                    } else {
                        if let customMetaData = metaData?.customMetadata {
                            let image = AcessibilityImage(data: imageData!, acessibilityLabel: customMetaData[ImagesAcessibilityAtributes.acessibilityLabel_pt.rawValue]!,
                                acessibilityHint: customMetaData[ImagesAcessibilityAtributes.acessibilityHint_pt.rawValue]!)
                            DispatchQueue.main.async {
                                completion(nil,image)
                            }
                        }
                    }
                }*/
            }
        }
    }
    
    static func update(images urls : [String], metadata: [String:String],on folder: ImagesFolders) {
        for url in urls {
            let imageRef = storageRoot.child(folder.rawValue+url)
            
            let metaData = StorageMetadata()
            metaData.customMetadata = [
                "acessibilityLabel_pt" : metadata["acessibilityLabel_pt"]!,
                "acessibilityHint_pt": metadata["acessibilityHint_pt"]!,
                "acessibilityLabel_en": metadata["acessibilityLabel_en"]!,
                "acessibilityHint_en": metadata["acessibilityHint_en"]!
            ]
            
            imageRef.updateMetadata(metaData) { (data, error) in
                if let errorMessage = error?.localizedDescription {
                    print(errorMessage)
                }
            }
        }
    }
    
    /*static func getCase(image url : String, completion: @escaping (String?, Data?) -> ()) {
        let folder = ImagesFolders.casesImages.rawValue
        storageRoot.child(folder+url).getData(maxSize: .max) { (imageData, error) in
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage,nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil,imageData)
                }
            }
        }
    }*/
    
    /*static func uploadImageFrom(url: URL, completion: @escaping (String?) -> () ) {
        storageRoot.putFile(from: url, metadata: nil) { (metaData, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage)
            } else {
                completion(nil)
            }
        }
    }*/
    
    static func uploadCaseImage(data: Data, imageName: String, completion: @escaping (String?) -> ()) {
        let folder = ImagesFolders.casesImages.rawValue
        let imgReference = storageRoot.child(folder+imageName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let uploadProgressTask = imgReference.putData(data, metadata: metadata) { (_, error) in
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        
        uploadProgressTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
    }
}
