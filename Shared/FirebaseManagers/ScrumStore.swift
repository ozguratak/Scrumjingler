//
//  ScrumStore.swift
//  Scrumdinger (iOS)
//
//  Created by Tengku Zulfadli on 11/9/2022.
//

import Foundation
import SwiftUI
import FirebaseStorage

class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []
    
    let storage = Storage.storage()
    let scrumsRef = Storage.storage().reference(withPath: "Scrums")
    enum mode{
        case allUser
        case onlyOwner
    }

    func downloadScrums(mode: mode, completion: @escaping (Result<[DailyScrum], Error>) -> Void) {
        var scrums: [DailyScrum] = []
        
        scrumsRef.listAll { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            for item in result!.items {
                dispatchGroup.enter()
                item.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                    defer { dispatchGroup.leave() }
                    
                    if let error = error {
                        print("Error downloading scrum data: \(error)")
                    } else if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let scrumData = try decoder.decode(DailyScrum.self, from: data)
                            scrums.append(scrumData)
                            switch mode{
                            case .allUser:
                                self.scrums = scrums
                            case .onlyOwner:
                                for scrum in scrums{
                                    for scrumID in currentUserInformations[keyUserScrums] as! [String] {
                                        if scrum.id == scrumID {
                                            self.scrums.append(scrum)
                                        }
                                    }
                                }
                            }
                            
                        } catch let error {
                            print("Error decoding scrum data: \(error)")
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(.success(scrums))
            }
        }
    }
    
}


extension DailyScrum {
    
    static let storageRef = Storage.storage().reference().child("Scrums")
    
    @discardableResult
    static func save(id: String?, scrums: [DailyScrum]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            let group = DispatchGroup()
            var totalSaved = 0
            for scrum in scrums {
                group.enter()
                save(id: id, scrum: scrum) { result in
                    switch result {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .success(let saved):
                        totalSaved += saved
                    }
                    group.leave()
                }
            }
            group.notify(queue: .global()) {
                continuation.resume(returning: totalSaved)
            }
        }
    }
    
    static func save(id: String?, scrum: DailyScrum, completion: @escaping (Result<Int, Error>)->Void) {
        do {
            var filename: String
            let data = try JSONEncoder().encode(scrum)
            
            if let ids = id{
                filename = ids
            } else {
                filename = "\(scrum.id)"
            }
                  
            let scrumRef = storageRef.child(filename)
            scrumRef.putData(data, metadata: nil) { metadata, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(1))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
}

