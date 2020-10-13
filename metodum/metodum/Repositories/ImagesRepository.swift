
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
    
    static func updateImageMetaData(image url : String, on folder: ImagesFolders) {
        let imageRef = storageRoot.child(folder.rawValue+url)
        
        let metaData = StorageMetadata()
        metaData.customMetadata = [
            "acessibilityLabel_pt" : "Aprendizado Baseado em superação de desafios",
            "acessibilityHint_pt": "A arte contém um fundo amarelo e mostra um estudante ruivo próximo de uma pilha de livros alta. Ele está prestes a subir escadas para concluir seu desafio, onde, no topo da pilha, um troféu o aguarda junto de um robô roxo, que o incentiva a subir.",
            "acessibilityLabel_en": "Challenge Based Learning",
            "acessibilityHint_en": "The picture shows an illustration representing the Challenge Based Learning. It contains a yellow background and a redhead student next to a tall stack of books. He is about to climb the stairs to complete his challenge, where, atop of the stack, a trophy awaits him along with a purple robot, that is encouraging him to go up."
            
        ]
        
        imageRef.updateMetadata(metaData) { (data, error) in
            if let errorMessage = error?.localizedDescription {
                print(errorMessage)
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
