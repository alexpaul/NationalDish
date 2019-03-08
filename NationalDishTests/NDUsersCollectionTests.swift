//
//  NDUsersCollectionTests.swift
//  NationalDishTests
//
//  Created by Alex Paul on 3/8/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
import FirebaseAuth
import Firebase
@testable import NationalDish

class NDUsersCollectionTests: XCTestCase {

  //let email = "bob1@bob1.com"
  //let email = "alex@alex.com"
  //let email = "kona@kona.com"
  let email = "istishna@istishna.com"
  let password = "123456"
  var currentUser: User?
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    FirebaseApp.configure()
    testSignInExistingAuthenticatedAccount()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testCreateAuthenticatedAccount() {
    let newEmailAccount = "istishna@istishna.com"
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
  
  func testCreateDBUser() {
    let exp = expectation(description: "created db user")
    let userId = currentUser?.uid ?? ""
    DBService.firestoreDB
      .collection(NDUsersCollectionKeys.CollectionKey)
      .document(userId)
      .setData(["displayName" : "istishna",
                "email"       : currentUser?.email ?? "",
                "joinedDate"  : Date.getISOTimestamp(),
                "photoURL"    : "",
                "userId"      : currentUser?.uid ?? ""
      ]) { (error) in
        if let error = error {
          XCTFail("failed to create db user with error: \(error.localizedDescription)")
        }
        exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
}
