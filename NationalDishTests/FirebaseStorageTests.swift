//
//  FirebaseStorageTests.swift
//  NationalDishTests
//
//  Created by Alex Paul on 3/8/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
import Toucan
@testable import NationalDish

class FirebaseStorageTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    FirebaseApp.configure()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testPostNationalDishImage() {
    let exp = expectation(description: "national dish image uploaded")
    let image = #imageLiteral(resourceName: "salt-fish-banana.jpeg")
    let resizeImage = Toucan(image: image).resize(CGSize(width: 500, height: 500))
    let userId = Auth.auth().currentUser?.uid ?? ""
    if let data = resizeImage.image?.jpegData(compressionQuality: 1.0) {
      StorageService.postImage(imageData: data, imageName: "nationalDishImages/\(userId)/documentId-goes-here") { (error, downloadURL) in
        if let error = error {
          XCTFail("posting image error: \(error.localizedDescription)")
        } else if let downloadURL = downloadURL {
          XCTAssertNotEqual(downloadURL.absoluteString, "", "should have a download url string")
        }
        exp.fulfill()
      }
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testPostProfileImage() {
    let exp = expectation(description: "profile image uploaded")
    let image = #imageLiteral(resourceName: "pitons.jpg")
    let resizeImage = Toucan(image: image).resize(CGSize(width: 500, height: 500))
    let userId = Auth.auth().currentUser?.uid ?? ""
    if let data = resizeImage.image?.jpegData(compressionQuality: 1.0) {
      StorageService.postImage(imageData: data, imageName: "profileImages/\(userId)") { (error, downloadURL) in
        if let error = error {
          XCTFail("posting image error: \(error.localizedDescription)")
        } else if let downloadURL = downloadURL {
          XCTAssertNotEqual(downloadURL.absoluteString, "", "should have a download url string")
        }
        exp.fulfill()
      }
    }
    wait(for: [exp], timeout: 3.0)
  }
  
}
