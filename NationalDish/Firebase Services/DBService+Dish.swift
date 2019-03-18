//
//  DBService+Dish.swift
//  NationalDish
//
//  Created by Alex Paul on 3/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct DishesCollectionKeys {
  static let CollectionKey = "dishes" // exact collection name on firebase
  static let CountryKey = "country"
  static let DishDescritionKey = "dishDescription"
  static let UserIdKey = "userId"
  static let CreatedDateKey = "createdDate"
  static let DocumentIdKey = "documentId"
  static let ImageURLKey = "imageURL"
}

extension DBService {
  // writing to firebase:
  // 1. we need a reference to the database - DBService.firestoreDB
  // 2. what collection are you writing to? e.g "dishes" (DishesCollectionKeys.CollectionKey)
  // 3. write to the collection e.g setData, updateData, delete
  // create new document - use setData
  // update existing document - use updateData
  static public func postDish(dish: Dish, completion: @escaping (Error?) -> Void) {
    DBService.firestoreDB.collection(DishesCollectionKeys.CollectionKey)
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
    // steps for deleting
    // step1: we need the database reference (DBService.firestoreDB)
    // step2: get the collection we're interested in
    // step3: pass in the dish's document id you want to delete
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
}
