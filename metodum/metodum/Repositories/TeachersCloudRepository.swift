//  TeachersCloudRepository.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum Collections : String {
    case teachers
    case classes
    case methods
    case cases
    case students
}

class TeachersCloudRepository {
    
    private static let teachersCollection = Firestore.firestore().collection(Collections.teachers.rawValue)
    
    static func setTeacherClassesChangesListener(teacherId: String ,completion: @escaping (String?,[SchoolClass]?) -> ()) {
        teachersCollection.document(teacherId).collection(Collections.classes.rawValue).addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error.localizedDescription,[])
                }
            } else {
                var classes : [SchoolClass]? = []
                classes = querySnapshot?.documents.map({ (queryDocumentSnapshot) -> SchoolClass in
                    return SchoolClass.fromJson(json: queryDocumentSnapshot.data())
                })
                DispatchQueue.main.async {
                    completion(nil, classes)
                }
            }
        }
    }
    
    static func addClassForTeacher(teacherUid: String, schoolClass: SchoolClass) {
        teachersCollection.document(teacherUid).collection(Collections.classes.rawValue).addDocument(data: schoolClass.toJson())
    }
    
    static func addMethodForTeacher(teacherUid: String, method : Methodology, completion: @escaping (String?) -> ()) {
        teachersCollection.document(teacherUid).collection(Collections.methods.rawValue).addDocument(data: ["uid" : method.uid]) {
            (error) in
            DispatchQueue.main.async {
                if let errorMessage = error?.localizedDescription {
                    completion(errorMessage)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    static func removeMethodForTeacher(teacherUid: String, favoriteMethodUid : String, completion: @escaping (String?) -> ()) {
        let query = teachersCollection.document(teacherUid).collection(Collections.methods.rawValue).whereField("uid", in: [favoriteMethodUid])
        query.getDocuments { (querySnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage)
            } else {
                querySnapshot?.documents.first?.reference.delete(completion: { (error) in
                    DispatchQueue.main.async {
                        if let errorMessage = error?.localizedDescription {
                            completion(errorMessage)
                        } else {
                            completion(nil)
                        }
                    }
                })
            }
        }
    }
    
    static func addCaseForTeacher(teacherUid: String, favoriteCase : Case, completion: @escaping (String?) -> ()) {
        teachersCollection.document(teacherUid).collection(Collections.cases.rawValue).addDocument(data: ["uid" : favoriteCase.caseUid]) { (error) in
            DispatchQueue.main.async {
                if let errorMessage = error?.localizedDescription {
                    completion(errorMessage)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    static func removeCaseForTeacher(teacherUid: String, favoriteCaseUid : String, completion: @escaping (String?) -> ()) {
        let query = teachersCollection.document(teacherUid).collection(Collections.cases.rawValue).whereField("uid", in: [favoriteCaseUid])
        query.getDocuments { (querySnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                completion(errorMessage)
            } else {
                querySnapshot?.documents.first?.reference.delete(completion: { (error) in
                    DispatchQueue.main.async {
                        if let errorMessage = error?.localizedDescription {
                            completion(errorMessage)
                        } else {
                            completion(nil)
                        }
                    }
                })
            }
        }
    }
    
    static func getFavoriteMethodsUidsForTeacher(teacherUid: String, completion: @escaping (String?, [String]?) -> ()) {
        teachersCollection.document(teacherUid).collection(Collections.methods.rawValue).getDocuments { (querySnapshot, error) in
            print("entrou no completion pelo menos")
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage,nil)
                }
            } else {
                var uids : [String] = []
                for document in querySnapshot!.documents {
                    let uid = document.data()["uid"] as! String
                    uids.append(uid)
                }
                DispatchQueue.main.async {
                    completion(nil,uids)
                }
            }
        }
    }
    
    static func getFavoriteCasesUidsForTeacher(teacherUid: String, completion: @escaping (String?, [String]?) -> ()) {
        teachersCollection.document(teacherUid).collection(Collections.cases.rawValue).getDocuments { (querySnapshot, error) in
            print("entrou no completion pelo menos")
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage,nil)
                }
            } else {
                var uids : [String] = []
                for document in querySnapshot!.documents {
                    let uid = document.data()["uid"] as! String
                    uids.append(uid)
                }
                DispatchQueue.main.async {
                    completion(nil,uids)
                }
            }
        }
    }
    
    static func get(teacherId : String, completion: @escaping (String?,Teacher?) -> ()) {
        teachersCollection.document(teacherId).getDocument { (docSnapshot, error) in
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage, nil)
                }
            } else {
                if let data = docSnapshot?.data() {
                    let teacher = Teacher.fromJson(json: data)
                    DispatchQueue.main.async {
                        completion(nil, teacher)
                    }
                }
            }
        }
    }
    
    static func initialize(teacher: Teacher,completion: @escaping (String?, Teacher?) -> ()) {
        teachersCollection.document(teacher.uid).setData(teacher.toJson()) { (error) in
            //print("foi irmao")
            //print(teacher)
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage,nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, teacher)
                }
            }
        }
    }
    /*static func setTeacherCasesChangesListener(teacherId: String ,completion: @escaping (String?,[SchoolClass]?) -> ()) {
        teachersCollection.document(teacherId).collection(Collections.classes.rawValue).addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                completion(error.localizedDescription,[])
            } else {
                var classes : [SchoolClass]? = []
                classes = querySnapshot?.documents.map({ (queryDocumentSnapshot) -> SchoolClass in
                    return SchoolClass.fromJson(json: queryDocumentSnapshot.data())
                })
                completion(nil, classes)
            }
        }
    }
    
    static func setTeacherMethodsChangesListener(teacherId: String ,completion: @escaping (String?,[SchoolClass]?) -> ()) {
        teachersCollection.document(teacherId).collection(Collections.classes.rawValue).addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                completion(error.localizedDescription,[])
            } else {
                var classes : [SchoolClass]? = []
                classes = querySnapshot?.documents.map({ (queryDocumentSnapshot) -> SchoolClass in
                    return SchoolClass.fromJson(json: queryDocumentSnapshot.data())
                })
                completion(nil, classes)
            }
        }
    }
    
    static func setTeacherStudentsChangesListener(teacherId: String ,completion: @escaping (String?,[SchoolClass]?) -> ()) {
        teachersCollection.document(teacherId).collection(Collections.classes.rawValue).addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                completion(error.localizedDescription,[])
            } else {
                var classes : [SchoolClass]? = []
                classes = querySnapshot?.documents.map({ (queryDocumentSnapshot) -> SchoolClass in
                    return SchoolClass.fromJson(json: queryDocumentSnapshot.data())
                })
                completion(nil, classes)
            }
        }
    }*/
}

