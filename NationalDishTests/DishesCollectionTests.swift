//
//  DishesCollectionTests.swift
//  NationalDishTests
//
//  Created by Alex Paul on 3/8/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
import FirebaseAuth
import Firebase
@testable import NationalDish

class DishesCollectionTests: XCTestCase {

  //let email = "bob1@bob1.com"
  //let email = "alex@alex.com"
  let email = "istishna@istishna.com"
  let password = "123456"
  var currentUser: User?
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    FirebaseApp.configure()
    //testSignInExistingAuthenticatedAccount()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testCreateAuthenticatedAccount() {
    let newEmailAccount = "anh@anh.com"
    let exp = expectation(description: "created user")
    Auth.auth().createUser(withEmail: newEmailAccount, password: "123456") { (authDataResult, error) in
      if let error = error {
        XCTFail("fail to create user account with error: \(error)")
      } else if let authDataResult = authDataResult {
        XCTAssertEqual(authDataResult.user.email, newEmailAccount, "email should be equal")
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testSignInExistingAuthenticatedAccount() {
    let exp = expectation(description: "user signed in")
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authDataResult, error) in
      if let error = error {
        XCTFail("fail to sign in user account with error: \(error)")
      } else if let authDataResult = authDataResult {
        self?.currentUser = authDataResult.user
        XCTAssertEqual(authDataResult.user.email, self?.email, "email should be equal")
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testSignOutAuthenticatedUser() {
    let exp = expectation(description: "user was signed out")
    do {
      try Auth.auth().signOut()
      exp.fulfill()
    } catch {
      XCTFail("failed to sign out user with error: \(error)")
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testCreateNationalDish() {
    let exp = expectation(description: "dish created")
    let documentRef = DBService.firestoreDB.collection(DishesCollectionKeys.CollectionKey).document()
    DBService.firestoreDB
      .collection(DishesCollectionKeys.CollectionKey)
      .document(documentRef.documentID)
      .setData([DishesCollectionKeys.DocumentIdKey : documentRef.documentID,
                "country"         : "Sweden",
                "createdDate"     : Date.getISOTimestamp(), 
                "userId"          : currentUser?.uid ?? "no user id",
                "dishDescription" : "Swedish Meatballs",
                "imageURL"        : "https://i1.wp.com/blog.ingredientmatcher.com/wp-content/uploads/2014/06/SwedishMeatballs1.jpg"
      ]) { (error) in
        if let error = error {
          XCTFail("failed to create national dish with error: \(error.localizedDescription)")
        }
        exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testFetchNationalDishes() {
    let exp = expectation(description: "fetched dishes")
    DBService.firestoreDB
      .collection(DishesCollectionKeys.CollectionKey)
      .getDocuments { (snapshot, error) in
        if let error = error {
          XCTFail("failed to fetch dishes with error: \(error.localizedDescription)")
        } else if let snapshot = snapshot {
          XCTAssertGreaterThan(snapshot.documents.count, 0, "should have more than 0 documents")
        }
        exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
}
