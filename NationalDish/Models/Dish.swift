//
//  Dish.swift
//  NationalDish
//
//  Created by Alex Paul on 3/7/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct Dish {
  let country: String
  let dishDescription: String
  let documentId: String
  let createdDate: String
  let imageURL: String
  let userId: String
  
  // mostly used for posting to firebase
  init(country: String, dishDescription: String, documentId: String, createdDate: String, imageURL: String, userId: String) {
    self.country = country
    self.dishDescription = dishDescription
    self.documentId = documentId
    self.createdDate = createdDate
    self.imageURL = imageURL
    self.userId = userId
  }
  
  // used to read a snapshot from firebase - snapshot.data() is a dictionary
  init(dict: [String: Any]) {
    self.country = dict[DishesCollectionKeys.CountryKey] as? String ?? ""
    self.dishDescription = dict[DishesCollectionKeys.DishDescritionKey] as? String ?? ""
    self.documentId = dict[DishesCollectionKeys.DocumentIdKey] as? String ?? ""
    self.createdDate = dict[DishesCollectionKeys.CreatedDateKey] as? String ?? ""
    self.imageURL = dict[DishesCollectionKeys.ImageURLKey] as? String ?? ""
    self.userId = dict[DishesCollectionKeys.UserIdKey] as? String ?? ""
  }
}
