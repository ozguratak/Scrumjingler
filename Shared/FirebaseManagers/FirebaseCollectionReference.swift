//
//  FirebaseCollectionReference.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 28.03.2023.
//


//MARK: - FireStore referans codes

import Foundation
import FirebaseFirestore
import Firebase

enum FCollectionReference: String{
    case User
    case Scrums
    case History
}
func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
