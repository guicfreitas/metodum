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
    
    static func addClassForTeacher(teacherUid: String, schoolClass: SchoolClass) {
        teachersCollection.document(teacherUid).collection(Collections.classes.rawValue).addDocument(data: schoolClass.toJson())
    }
    
    static func addMethodForTeacher(teacherUid : String, method : Methodology) {
        teachersCollection.document(teacherUid).collection(Collections.methods.rawValue).addDocument(data: ["uid" : method.uid])
    }
    
    static func addCaseForTeacher(teacherUid : String, favoriteCase : Case) {
        teachersCollection.document(teacherUid).collection(Collections.cases.rawValue).addDocument(data: ["uid" : favoriteCase.caseUid])
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

