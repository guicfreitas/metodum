//
//  AuthService.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let auth = Auth.auth()
    
    static func verifyAuthentication(completion: @escaping (User?) -> ()){
        auth.addStateDidChangeListener { (nAuth, user) in
            if let user = user {
                print("logado")
                print(Locale.current.languageCode)
                let loggedUser = User(uuid: user.uid, email: user.email!)
                completion(loggedUser)
            } else {
                print("nao logado")
                completion(nil)
            }
        }
    }
    
    static func createUserWithEmailAndPassword(email: String,password: String,completion: @escaping (String?) -> ()){
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    static func signInWithEmailAndPassword(email: String, password: String, completion: @escaping (String?) -> ()) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    static func signOut(completion: @escaping (String?) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch (let error) {
            completion(error.localizedDescription)
        }
    }
}
