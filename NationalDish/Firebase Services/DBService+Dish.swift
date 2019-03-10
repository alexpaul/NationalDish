//
//  DBService+Dish.swift
//  NationalDish
//
//  Created by Alex Paul on 3/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct DishesCollectionKeys {
  static let CollectionKey = "dishes"
  static let CountryKey = "country"
  static let DishDescritionKey = "dishDescription"
  static let UserIdKey = "userId"
  static let CreatedDateKey = "createdDate"
  static let DocumentIdKey = "documentId"
  static let ImageURLKey = "imageURL"
}

extension DBService {
  static public func postDish(dish: Dish, completion: @escaping (Error?) -> Void) {
    firestoreDB.collection(DishesCollectionKeys.CollectionKey)
      .document(dish.documentId).setData([
        DishesCollectionKeys.CreatedDateKey     : dish.createdDate,
        DishesCollectionKeys.CountryKey         : dish.country, 
        DishesCollectionKeys.UserIdKey          : dish.userId,
        DishesCollectionKeys.DishDescritionKey  : dish.dishDescription,
        DishesCollectionKeys.ImageURLKey        : dish.imageURL,
        DishesCollectionKeys.DocumentIdKey      : dish.documentId
        ])
      { (error) in
        if let error = error {
          completion(error)
        } else {
          completion(nil)
        }
    }
  }
  
  static public func deleteDish(dish: Dish, completion: @escaping (Error?) -> Void) {
    DBService.firestoreDB
      .collection(DishesCollectionKeys.CollectionKey)
      .document(dish.documentId)
      .delete { (error) in
        if let error = error {
          completion(error)
        } else {
          completion(nil)
        }
    }
  }
  
  static public func fetchDishCreator(userId: String, completion: @escaping (Error?, NDUser?) -> Void) {
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
