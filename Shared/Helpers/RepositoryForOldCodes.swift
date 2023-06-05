//
//  RepositoryForOldCodes.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 30.03.2023.
//
//MARK: - OLD LOAD DATA CODES
/*
     private static func fileUrl() throws -> URL {
         try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
             .appendingPathComponent("scrums.data")
     }
 
     static func load() async throws -> [DailyScrum] {
         try await withCheckedThrowingContinuation { continuation in
             load { result in
                 switch result {
                 case .failure(let error):
                     continuation.resume(throwing: error)
                 case .success(let scrums):
                     continuation.resume(returning: scrums)
                 }
             }
         }
     }
 
     static func load(completion: @escaping (Result<[DailyScrum], Error>)->Void) {
         DispatchQueue.global(qos: .background).async {
             do {
                 let fileUrl = try fileUrl()
                 guard let file = try? FileHandle(forReadingFrom: fileUrl) else {
                     DispatchQueue.main.async {
                         completion(.success([]))
                     }
                     return
                 }
                 let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                 DispatchQueue.main.async {
                     completion(.success(dailyScrums))
                 }
             } catch {
                 DispatchQueue.main.async {
                     completion(.failure(error))
                 }
             }
         }
     }
 
 //MARK: -
 
 */
