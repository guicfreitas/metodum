
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
    case acessibilityLabel = "acessibilityLabel"
    case acessibilityHint = "acessibilityHint"
}

class ImagesRepository {
    static let storageRoot = Storage.storage().reference()
    
    static func getMethod(image url : String, completion: @escaping (String?, AcessibilityImage?) -> ()) {
        let folder = ImagesFolders.methodologiesImages.rawValue
        let imageRef = storageRoot.child(folder+url)
        
        imageRef.getData(maxSize: .max) { (imageData, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                imageRef.getMetadata { (metaData, error) in
                    if let errorMessage = error?.localizedDescription {
                        completion(errorMessage,nil)
                    } else {
                        if let customMetaData = metaData?.customMetadata {
                            let image = AcessibilityImage(data: imageData!, acessibilityLabel: customMetaData[ImagesAcessibilityAtributes.acessibilityLabel.rawValue]!,
                                acessibilityHint: customMetaData[ImagesAcessibilityAtributes.acessibilityHint.rawValue]!)
                            completion(nil,image)
                        }
                    }
                }
            }
        }
    }
    
    static func updateImageMetaData(image url : String) {
        let folder = ImagesFolders.methodologiesImages.rawValue
        let imageRef = storageRoot.child(folder+url)
        
        let metaData = StorageMetadata()
        metaData.customMetadata = [
            ImagesAcessibilityAtributes.acessibilityLabel.rawValue : "FLAMENGO PORRA",
            ImagesAcessibilityAtributes.acessibilityHint.rawValue : "FLUMINENSE FREGUES"
        ]
        
        imageRef.updateMetadata(metaData) { (data, error) in
            if let errorMessage = error?.localizedDescription {
                print(error)
            }
            else {
                print(data)
            }
        }
    }
    
    static func getCase(image url : String, completion: @escaping (String?, Data?) -> ()) {
        let folder = ImagesFolders.casesImages.rawValue
        storageRoot.child(folder+url).getData(maxSize: .max) { (imageData, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                completion(nil,imageData)
            }
        }
    }
    
    static func getMetadata() {
        
    }
}
