//  CasesCloudRepository.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 25/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum CasesSubCollections : String {
    case aprovedCases
    case casesInAnalyzes
}

class CasesCloudRepository {
    
    static let casesCollection = Firestore.firestore().collection("cases")
    
    static func getAllCases(completion: @escaping (String?,[Case]?) -> ()) {
        casesCollection.getDocuments { (querySnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage, nil)
            } else {
                let cases = querySnapshot?.documents.map({ (document) -> Case in
                    print(document.data())
                    return Case.fromJson(json: document.data())
                })
                completion(nil,cases)
            }
        }
    }
    
    static func addCase(newCase: Case, completion: @escaping (String?) -> ()) {
        let docRef = Firestore.firestore().collection("casesInAnalyzes").addDocument(data: newCase.toJson()) { (error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage)
            } else {
                completion(nil)
            }
        }
        docRef.updateData(["caseUid" : docRef.documentID])
    }
    
    static func query(casesUids: [String], language: String,completion: @escaping (String?, [Case]?) -> ()) {
        let query = casesCollection.whereField("caseUid", in: casesUids)
        query.getDocuments { (querySnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                var cases = [Case]()
                print(querySnapshot?.count)
                for document in querySnapshot!.documents {
                    let favoriteCase = Case.fromJson(json: document.data())
                    cases.append(favoriteCase)
                }
                completion(nil, cases)
            }
        }
    }
}
