//
//  AuthenticationManager.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 28.03.2023.
//

import Foundation
import FirebaseAuth
import UIKit

class AuthenticationManager {
    
    enum toggle{
        case add
        case remove
    }
    
    
    class func currentId() -> String {
          return  Auth.auth().currentUser!.uid
      }
      
    func currentUser() -> User? {
          var result: User?
          if Auth.auth().currentUser != nil {
              if let dictionary = UserDefaults.standard.object(forKey: keyCurrentUser) {
                  result = User.init(_dictionary: dictionary as! NSDictionary)
                  return User.init(_dictionary: dictionary as! NSDictionary)
              }
          }
          return result
      }
      
      //MARK: - User login, register and logout functions
      
      func loginUser(email: String, password: String, completion: @escaping (_ error: Error?, _ verified: Bool, _ Id: String) -> Void) {
          
          Auth.auth().signIn(withEmail: email, password: password) { ( authDataResult, error) in
              if error == nil {
                  if authDataResult!.user.isEmailVerified {
                      userID = Auth.auth().currentUser!.uid
                      self.getUserInformations()
                      completion(error, true, userID)
                  } else {
                      authDataResult!.user.sendEmailVerification()
                      userID = Auth.auth().currentUser!.uid
                      self.getUserInformations()
                      completion(error, false, "")
                  }
              } else {
                  completion(error, false, "")
              }
          }
      }
    
    func getUserInformations() {
        User().downloadUserFromFirestore { userArray in
            if !userArray.isEmpty {
                for users in userArray{
                    if users.objectID == userID {
                        currentUserInformations[keyUserName] = users.firstName
                        currentUserInformations[keyUserLastName] = users.lastName
                        currentUserInformations[keyUserScrumsTranscripts] = users.scrumTranscripts
                        currentUserInformations[keyUserScrums] = users.scrums
                        currentUserInformations[keyUserPath] = users.objectID
                    }
                }
            }
        }
    }
    
    func updateScrumHistory(history: History, scrumID: String) {
        var historyList = currentUserInformations[keyUserScrumsTranscripts] as! [String]
        historyList.append(history.transcript ?? "")
        
        firebaseReference(.User).document(userID).updateData([keyUserScrumsTranscripts : history.transcript ?? ""])
    }
    
    func updateScrumList(state: toggle, scrumID: String) -> Bool {
        var scrumList = currentUserInformations[keyUserScrums] as! [String]
        switch state{
        case .add:
            scrumList.append(scrumID)
            firebaseReference(.User).document(userID).updateData([keyUserScrums : scrumList])
            return true
        case .remove:
            let index = scrumList.firstIndex(of: scrumID)
            if let index = index {
                scrumList.remove(at: index)
                firebaseReference(.User).document(userID).updateData([keyUserScrums : scrumList])
                return true
            } else {
                return false
            }
        }
    }
      
    func registerUser(email: String, password: String, name: String, lastName: String, completion: @escaping (_ error: Error?) -> Void) {
          
          Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
              
              completion(error)
              if error == nil {
                  User().createUserSet(id: AuthenticationManager.currentId(), mail: email, name: name, lastName: lastName)
                  authDataResult!.user.sendEmailVerification { error in
                      print("auth e mail verification error : \(String(describing: error))")
                  }
                  
              } else {
                  print("user creating error: \(String(describing: error))")
              }
          }
      }
   
    func logout() {
        do {
            try Auth.auth().signOut()
            print("oturum kapatıldı!")
        } catch {
                print("logout error!")
            }
    }
    
      
      //MARK: - Send e-mail to user
      
      func mailSender() {
          
      }
  }

  extension User {
      func userDictionaryFrom(_ user: User) -> NSDictionary {
          return NSDictionary(objects: [user.email, user.firstName, user.lastName, user.objectID, user.scrumTranscripts, user.scrums, user.onBoard, user.profileImageLinks], forKeys: [keyUserEmail as NSCopying, keyUserName as NSCopying, keyUserLastName as NSCopying, keyUserPath as NSCopying, keyUserScrumsTranscripts as NSCopying, keyUserScrums as NSCopying, keyUserOnBoard as NSCopying, keyUserImages as NSCopying])
      }
      
      func saveUserToFirestore(_ user: User) {
          firebaseReference(.User).document(String(describing: user.objectID)).setData(userDictionaryFrom(user) as! [String : Any])
      }
      
      func downloadUserFromFirestore(completion: @escaping (_ userArray: [User]) -> Void) {
          
          var userArray: [User] = []
          
          firebaseReference(.User).getDocuments { snapshot, error in
              guard let snapshot = snapshot
              else {
                  completion(userArray)
                  return
              }
              
              if !snapshot.isEmpty {
                  for usersDict in snapshot.documents {
                      userArray.append(User(_dictionary: usersDict.data() as NSDictionary))
                  }
              }
              completion(userArray)
          }
      }
      
      func createUserSet(id: String, mail: String, name: String, lastName: String) {
          let user = User(_objectId: id, _eMail: mail, _name: name, _lastName: lastName)
          self.saveUserToFirestore(user)
      }
      

      
      func updateUserInformations(name: String, lastName: String, scrumsTranscripts: [String], scrums: [DailyScrum], profileImage: [UIImage?]) {
          
          let user = User()
          
          user.objectID = userID
          user.email = currentEmail
          user.firstName = name
          user.lastName = lastName
          user.onBoard = true
          user.scrumTranscripts = []
          user.scrums = []
          
          
          if profileImage.count > 0 {
              uploadImages(images: profileImage, imageFileName: "ProfileImages", itemID: userID) { (imageLinkArray) in
                  user.profileImageLinks = imageLinkArray
                  self.saveUserToFirestore(user)
              }
              
          } else {
              self.saveUserToFirestore(user)
          }
          
          
      }
      
      func changePassword(newPassword: String) {
          let user = User()
          Auth.auth().currentUser?.reload()
          Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { error in
              if error != nil {
                 print("password change error")
              } else {
                  user.objectID = userID
                  self.saveUserToFirestore(user)
                  
              }
          })
      }
      
      func changeMail(newMail: String) {
          let user = User()
          Auth.auth().currentUser?.reload()
          Auth.auth().currentUser?.updateEmail(to: newMail, completion: { error in
              if error != nil {
                  print("email change error")
              } else {
                  user.objectID = userID
                  user.email = newMail
                  self.saveUserToFirestore(user)
              }
          })
      }
      
      func resendVerifyMail() {
          let user = Auth.auth().currentUser
          user?.reload()
          if user?.isEmailVerified == false {
              user?.sendEmailVerification()
              
          }
      }
      
      func deleteUser() {
          let user = Auth.auth().currentUser
          user?.delete()
      }
  

class func currentId() -> String {
    return  Auth.auth().currentUser!.uid
}

class func currentUser() -> User? {
    var result: User?
    if Auth.auth().currentUser != nil {
        if let dictionary = UserDefaults.standard.object(forKey: keyCurrentUser) {
            result = User.init(_dictionary: dictionary as! NSDictionary)
            return User.init(_dictionary: dictionary as! NSDictionary)
        }
    }
    return result
}

}
