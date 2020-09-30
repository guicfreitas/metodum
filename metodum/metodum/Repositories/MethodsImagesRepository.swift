
//  MethodsImagesRepository.swift
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

class MethodsImagesRepository {
    static let storageRoot = Storage.storage().reference()
    
    static func getMethod(image url : String, completion: @escaping (String?, Data?) -> ()) {
        let folder = ImagesFolders.methodologiesImages.rawValue
        storageRoot.child(folder+url).getData(maxSize: .max) { (imageData, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                completion(nil,imageData)
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
}
