//
//  DBService.swift
//  NationalDish
//
//  Created by Alex Paul on 3/7/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct NDUsersCollectionKeys {
  static let CollectionKey = "users"
  static let ReviewerIdKey = "userId"
  static let DisplayNameKey = "displayName"
  static let FirstNameKey = "firstName"
  static let LastNameKey = "lastName"
  static let EmailKey = "email"
  static let PhotoURLKey = "photoURL"
  static let JoinedDateKey = "joinedDate"
}

struct DishesCollectionKeys {
  static let CollectionKey = "dishes"
  static let DishDescritionKey = "dishDescription"
  static let UserIdKey = "userId"
  static let CreatedDateKey = "createdDate"
  static let DocumentIdKey = "documentId"
  static let ImageURLKey = "imageURL"
}

final class DBService {
  private init() {}
  
  public static var firestoreDB: Firestore = {
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    return db
  }()
  
  static public var generateDocumentId: String {
    return firestoreDB.collection(NDUsersCollectionKeys.CollectionKey).document().documentID
  }
  
  static public func createNDUser(user: NDUser, completion: @escaping (Error?) -> Void) {
    firestoreDB.collection(NDUsersCollectionKeys.CollectionKey)
      .document(user.userId)
      .setData([ DishesCollectionKeys.UserIdKey : user.userId,
                 NDUsersCollectionKeys.DisplayNameKey : user.displayName,
                 NDUsersCollectionKeys.EmailKey       : user.email,
                 NDUsersCollectionKeys.PhotoURLKey    : user.photoURL ?? "",
                 NDUsersCollectionKeys.JoinedDateKey  : user.joinedDate
      ]) { (error) in
        if let error = error {
          completion(error)
        } else {
          completion(nil)
        }
    }
  }
  
  static public func postDish(dish: Dish) {
    firestoreDB.collection(DishesCollectionKeys.CollectionKey)
      .document(dish.documentId).setData([
        DishesCollectionKeys.CreatedDateKey     : dish.createdDate,
        DishesCollectionKeys.UserIdKey          : dish.userId,
        DishesCollectionKeys.DishDescritionKey  : dish.dishDescription,
        DishesCollectionKeys.ImageURLKey        : dish.imageURL,
        DishesCollectionKeys.DocumentIdKey  : dish.documentId
        ])
      { (error) in
        if let error = error {
          print("posting dish error: \(error)")
        } else {
          print("dish posted successfully to ref: \(dish.documentId)")
        }
    }
  }
}
