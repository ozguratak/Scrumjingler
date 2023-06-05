//
//  ImageManager.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 28.03.2023.
//
//MARK: - If need any proccess for image upload/download to firebase discard the comment all codes


import Foundation
import UIKit
import FirebaseStorage


let storge = Storage.storage()
func uploadImages(images: [UIImage?], imageFileName: String, itemID: String, completion: @escaping (_ imageLinks: [String]) -> Void) {
    
    if Reachabilty.HasConnection(){
        
        var uploadedImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images {
            
            let fileName = imageFileName + "/" + itemID + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.01)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    uploadedImagesCount += 1
                    
                    if uploadedImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            nameSuffix += 1
        }
        
    } else {
        print("Internet Connection Error!")
    }
    
    //MARK: - Save Image to Firestore
    
    func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping (_ imageLink: String?) -> Void) {
        var task: StorageUploadTask!
        let storageRef = storge.reference(forURL: imageStorageLink).child(fileName)
        
        task = storageRef.putData(imageData, metadata: nil, completion: { metaData, error in
            task.removeAllObservers()
            
            if error != nil {
                print("IMAGE SAVE ERROR: \(String(describing: error))")
                completion(nil)
                return
            } else {
                storageRef.downloadURL { URL, error in
                    guard let downloadURL = URL else {
                        completion(nil)
                        
                        return
                    }
                    
                    completion(downloadURL.absoluteString)
                }
            }
        })
    }
}
//MARK: - Download images from Firestore

func downloadImagesFromFirestore(imageUrls: [String], completion: @escaping(_ images:[UIImage?]) -> Void) {
    
    var imageArray: [UIImage] = []
    
    var downloadCounter = 0

    for link in imageUrls {
        let url = NSURL(string: link)
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            downloadCounter += 1
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                imageArray.append(UIImage(data: data as! Data)! )
                
                if downloadCounter == imageArray.count {
                     
                    DispatchQueue.main.async {
                        completion(imageArray)
                    }
                }
            } else {
                print("Photo not found!")
                completion(imageArray)
            }
        }
        
    }
}


