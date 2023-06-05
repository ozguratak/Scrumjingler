//
//  User.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 28.03.2023.
//

import Foundation
class User {
    
    var objectID: String = ""
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var profileImageLinks: [String] = []
    var scrums: [String] = []
    var scrumTranscripts: [String] = []
    var onBoard: Bool = false
    
    
    //MARK: - Initiliazers
    init () {
        
    }
    
    init (_objectId: String, _eMail: String, _name: String, _lastName: String) {
        
        objectID = _objectId
        email = _eMail
        firstName = _name
        lastName = _lastName
        onBoard = false
        scrums = []
        scrumTranscripts = []
        profileImageLinks = []
        
    }
    
    init (_dictionary: NSDictionary) {
        if let userId = _dictionary[keyUserPath] {
            objectID = userId as? String ?? ""
        } else {
            objectID = ""
        }
        
        if let scrum = _dictionary[keyUserScrums] {
            scrums = scrum as? [String] ?? []
        } else {
            scrums = []
        }
        
        if let image = _dictionary[keyUserImages] {
            profileImageLinks = image as? [String] ?? []
        } else {
            profileImageLinks = []
        }
        
        if let mail = _dictionary[keyUserEmail] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fName = _dictionary[keyUserName] {
            firstName = fName as! String
        } else {
            firstName = ""
        }
        
        if let lName = _dictionary[keyUserLastName] {
            lastName = lName as! String
        } else {
            lastName = ""
        }
        
        if let oBoard = _dictionary[keyUserOnBoard] {
            onBoard = oBoard as! Bool
        } else {
            onBoard = false
        }
        
        if let history = _dictionary[keyUserScrumsTranscripts] {
            scrumTranscripts = history as? [String] ?? []
        } else {
            scrumTranscripts = []
        }
    }
}
