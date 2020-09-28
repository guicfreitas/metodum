//  CasesCloudRepository.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 25/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import FirebaseFirestore

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
}
