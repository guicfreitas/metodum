//  MethodsCloudRepository.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 23/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//
// o mais clicado vai estar no começo da fila, é só tirar o elemento do topo da fila pra colocar no em alta e o resto deixa pra collection embaixo
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
    
    /*static func getAllMethods(language: String, completion: @escaping (String?, [Methodology]?) -> ()) {
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
    }*/
    
    static func getAllMethods(language: String, completion: @escaping (String?, [Methodology]?) -> ()) {
        methodsCollection.document(language).collection("methods").getDocuments { (querySnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                var methodologies = querySnapshot?.documents.map({ (document) -> Methodology in
                    return Methodology.fromJson(json: document.data())
                })
                
                methodologies?.sort(by: { (a, b) -> Bool in
                    return a.clicksCount > b.clicksCount
                })
                
                completion(nil,methodologies)
            }
        }
    }
    
    static func incrementClicksCountFor(methodology: inout Methodology, language: String) {
        methodology.clicksCount += 1
        methodsCollection.document(language).collection("methods").document(methodology.uid).updateData(["clicksCount":methodology.clicksCount])
    }
}
