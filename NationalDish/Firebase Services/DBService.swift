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
}
