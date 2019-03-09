//
//  NDUser.swift
//  NationalDish
//
//  Created by Alex Paul on 3/7/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct NDUser {
  let userId: String
  let displayName: String
  let email: String
  let photoURL: String?
  let joinedDate: String
  
  init(userId: String, displayName: String, email: String, photoURL: String?, joinedDate: String) {
    self.userId = userId
    self.displayName = displayName
    self.email = email
    self.photoURL = photoURL
    self.joinedDate = joinedDate
  }
  
  init(dict: [String: Any]) {
    self.userId = dict[NDUsersCollectionKeys.UserIdKey] as? String ?? ""
    self.displayName = dict[NDUsersCollectionKeys.DisplayNameKey] as? String ?? ""
    self.email = dict[NDUsersCollectionKeys.EmailKey] as? String ?? ""
    self.photoURL = dict[NDUsersCollectionKeys.PhotoURLKey] as? String ?? ""
    self.joinedDate = dict[NDUsersCollectionKeys.JoinedDateKey] as? String ?? ""
  }
}


