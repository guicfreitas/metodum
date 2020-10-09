//  AuthService.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import FirebaseAuth
import CryptoKit
import AuthenticationServices

class AuthService {
    
    private static let auth = Auth.auth()
    static var currentNonce : String?
    
    static func verifyAuthentication(completion: @escaping (User?) -> ()){
        auth.addStateDidChangeListener { (nAuth, user) in
            if let user = user {
                //print("logado")
                //print(Locale.current.languageCode)
                //print(user.displayName)
                let loggedUser = User(uid: user.uid, email: user.email!, name: user.displayName ?? "")
                completion(loggedUser)
                
            } else {
                print("nao logado")
                completion(nil)
            }
        }
    }
    
    static func getUser() -> User? {
        if let user = auth.currentUser {
            return User(uid: user.uid, email: user.email!, name: user.displayName ?? "")
        }
        return nil
    }
    
    static func createUserWithEmailAndPassword(email: String,password: String,name: String,completion: @escaping (String?,User?) -> ()) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error.localizedDescription,nil)
            }
            
            if let user = result?.user {
                let userProfileRequest = user.createProfileChangeRequest()
                userProfileRequest.displayName = name
                userProfileRequest.commitChanges { (error) in
                    if let error = error {
                        completion(error.localizedDescription,nil)
                    } else {
                        let loggedUser = User(uid: user.uid, email: user.email!, name: user.displayName!)
                        completion(nil,loggedUser)
                    }
                }
            }
        }
    }
    
    static func signInWithEmailAndPassword(email: String, password: String, completion: @escaping (String?, User?) -> ()) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error.localizedDescription,nil)
            } else {
                if let user = result?.user {
                    let loggedUser = User(uid: user.uid, email: user.email!, name: user.displayName ?? "")
                    completion(nil, loggedUser)
                }
            }
        }
    }
    
    static func signInWith(appleIDTokenString: String,completion: @escaping (String?, User?) -> ()) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString, rawNonce: currentNonce)
        
        auth.signIn(with: credential) { (result, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage,nil)
            } else {
                if let user = result?.user {
                    let loggedUser = User(uid: user.uid, email: user.email!, name: user.displayName ?? "") 
                    completion(nil, loggedUser)
                }
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
