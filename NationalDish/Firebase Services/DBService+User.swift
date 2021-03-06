//
//  DBService+User.swift
//  NationalDish
//
//  Created by Alex Paul on 3/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct NDUsersCollectionKeys {
  static let CollectionKey = "users"
  static let UserIdKey = "userId"
  static let DisplayNameKey = "displayName"
  static let EmailKey = "email"
  static let PhotoURLKey = "photoURL"
  static let JoinedDateKey = "joinedDate"
}

extension DBService {
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
  
  static public func fetchUser(userId: String, completion: @escaping (Error?, NDUser?) -> Void) {
    DBService.firestoreDB
      .collection(NDUsersCollectionKeys.CollectionKey)
      .whereField(NDUsersCollectionKeys.UserIdKey, isEqualTo: userId)
      .getDocuments { (snapshot, error) in
        if let error = error {
          completion(error, nil)
        } else if let snapshot = snapshot?.documents.first {
          let dishCreator = NDUser(dict: snapshot.data())
          completion(nil, dishCreator)
        }
    }
  }
}
