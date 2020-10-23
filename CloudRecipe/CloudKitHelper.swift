//
//  CloudKitHelper.swift
//  CloudRecipe
//
//  Created by P. Kurt Thorderson on 10/21/20.
//

import Foundation
import SwiftUI
import CloudKit

struct CloudKitHelper {
  // MARK: - record types
  struct RecordType {
    static let Items = "Items"
  }
  // MARK: - error
  enum CloudKitHelperError: Error {
    case recordFailure
    case recordIDFailure
    case castFailure
    case cursorFailure
  }
  // MARK: - saving to CloudKit
      static func save(item: Recipe, completion: @escaping (Result<Recipe, Error>) -> ()) {
          let itemRecord = CKRecord(recordType: RecordType.Items)
          itemRecord["name"] = item.name as CKRecordValue
          
          CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, err) in
              DispatchQueue.main.async {
                  if let err = err {
                      completion(.failure(err))
                      return
                  }
                  guard let record = record else {
                      completion(.failure(CloudKitHelperError.recordFailure))
                      return
                  }
                  let recordID = record.recordID
                  guard let name = record["name"] as? String else {
                      completion(.failure(CloudKitHelperError.castFailure))
                      return
                  }
                  let recipe = Recipe(recordID: recordID, name: name)
                  completion(.success(recipe))
              }
          }
      }
//  static func save(item: Recipe, completion: @escaping (Result<Recipe, Error>) ->
//    ()) {
//    let itemRecord = CKRecord(recordType: RecordType.Items)
//    itemRecord["name"] = item.name as CKRecordValue
//    CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, err) in
//      if let err = err {
//        completion(.failure(err))
//        return
//      }
//      guard let record = record else {
//        completion(.failure(CloudKitHelperError.recordFailure))
//        return
//      }
//      let id = record.recordID
//      guard let name = record["name"] as? String else {
//        completion(.failure(CloudKitHelperError.castFailure))
//        return
//      }
//      let recipe = Recipe(recordID: id, name: name)
//      completion(.success(recipe))
//    }
//  }
  // MARK: - fetching from CloudKit
      static func fetch(completion: @escaping (Result<Recipe, Error>) -> ()) {
          let pred = NSPredicate(value: true)
          let sort = NSSortDescriptor(key: "creationDate", ascending: false)
          let query = CKQuery(recordType: RecordType.Items, predicate: pred)
          query.sortDescriptors = [sort]

          let operation = CKQueryOperation(query: query)
          operation.desiredKeys = ["name"]
          operation.resultsLimit = 50
          
          operation.recordFetchedBlock = { record in
              DispatchQueue.main.async {
                  let recordID = record.recordID
                  guard let name = record["name"] as? String else { return }
                  let recipe = Recipe(recordID: recordID, name: name)
                  completion(.success(recipe))
              }
          }
          
          operation.queryCompletionBlock = { (/*cursor*/ _, err) in
              DispatchQueue.main.async {
                  if let err = err {
                      completion(.failure(err))
                      return
                  }
  //                guard let cursor = cursor else {
  //                    completion(.failure(CloudKitHelperError.cursorFailure))
  //                    return
  //                }
  //                print("Cursor: \(String(describing: cursor))")
              }
              
          }
          
          CKContainer.default().publicCloudDatabase.add(operation)
      }

  // MARK: - delete from CloudKit
      static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
          CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
              DispatchQueue.main.async {
                  if let err = err {
                      completion(.failure(err))
                      return
                  }
                  guard let recordID = recordID else {
                      completion(.failure(CloudKitHelperError.recordIDFailure))
                      return
                  }
                  completion(.success(recordID))
              }
          }
      }
      
      // MARK: - modify in CloudKit
      static func modify(item: Recipe, completion: @escaping (Result<Recipe, Error>) -> ()) {
          guard let recordID = item.recordID else { return }
          CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, err in
              if let err = err {
                  DispatchQueue.main.async {
                      completion(.failure(err))
                  }
                  return
              }
              guard let record = record else {
                  DispatchQueue.main.async {
                      completion(.failure(CloudKitHelperError.recordFailure))
                  }
                  return
              }
              record["name"] = item.name as CKRecordValue

              CKContainer.default().publicCloudDatabase.save(record) { (record, err) in
                  DispatchQueue.main.async {
                      if let err = err {
                          completion(.failure(err))
                          return
                      }
                      guard let record = record else {
                          completion(.failure(CloudKitHelperError.recordFailure))
                          return
                      }
                      let recordID = record.recordID
                      guard let name = record["name"] as? String else {
                          completion(.failure(CloudKitHelperError.castFailure))
                          return
                      }
                      let recipe = Recipe(recordID: recordID, name: name)
                      completion(.success(recipe))
                  }
              }
          }
      }
  }

