//  MethodsCloudRepository.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 23/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import FirebaseFirestore

class MethodsCloudRepository {
    static private let methodsCollection = Firestore.firestore().collection("methodologies")
    
    /*static func getMethod(uid: String, language: String, completion: @escaping (String?, Methodology?) -> ()) {
        methodsCollection.document(uid).collection(language).getDocuments { (querySnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                if let json = querySnapshot?.documents.first?.data() {
                    let methodology = Methodology.fromJson(json: json)
                    print("methodology")
                    print(methodology)
                    completion(nil,methodology)
                }
            }
        }
    }*/
    
    static func getMethod(uid: String, language: String, completion: @escaping (String?, Methodology?) -> ()) {
        let document = methodsCollection.document(language).collection("methods").document(uid)
        document.getDocument { (documentSnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                let methodology = Methodology.fromJson(json: (documentSnapshot?.data())!)
                completion(nil, methodology)
            }
        }
    }
    
    static func getAllMethods(language: String, completion: @escaping (String?, [Methodology]?) -> ()) {
        methodsCollection.document(language).collection("methods").getDocuments { (querySnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                let methodologies = querySnapshot?.documents.map({ (document) -> Methodology in
                    return Methodology.fromJson(json: document.data())
                })
                completion(nil,methodologies)
            }
        }
    }
}
