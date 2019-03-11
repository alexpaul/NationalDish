//
//  EditProfileViewController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/8/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import Toucan

class EditProfileViewController: UIViewController {
  @IBOutlet weak var profileImageViewButton: CircularButton!
  @IBOutlet weak var displayNameTextField: UITextField!
  
  private var selectedImage: UIImage?
  private lazy var imagePickerController: UIImagePickerController = {
    let ip = UIImagePickerController()
    ip.delegate = self
    return ip
  }()
  private var authservice = AppDelegate.authservice
  
  public var profileImage: UIImage!
  public var displayName: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateProfileUI()
  }
  
  private func updateProfileUI() {
    profileImageViewButton.setImage(profileImage, for: .normal)
    displayNameTextField.text = displayName.replacingOccurrences(of: "@", with: "")
    selectedImage = profileImageViewButton.imageView?.image
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func saveEditProfileButtonPressed(_ sender: UIBarButtonItem) {
    navigationItem.rightBarButtonItem?.isEnabled = false
    guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0),
      let user = authservice.getCurrentUser(),
      let displayName = displayNameTextField.text,
      !displayName.isEmpty else {
        showAlert(title: "Missing Fields", message: "A photo and username are Required")
        return
    }
    StorageService.postImage(imageData: imageData, imageName: Constants.ProfileImagePath + user.uid) { [weak self] (error, imageURL) in
      if let error = error {
        self?.showAlert(title: "Error Saving Photo", message: error.localizedDescription)
      } else if let imageURL = imageURL {
        // update auth user and user db document
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        request.photoURL = imageURL
        request.commitChanges(completion: { (error) in
          if let error = error {
            self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
          }
        })
        DBService.firestoreDB
          .collection(NDUsersCollectionKeys.CollectionKey)
          .document(user.uid)
          .updateData([NDUsersCollectionKeys.PhotoURLKey    : imageURL.absoluteString,
                       NDUsersCollectionKeys.DisplayNameKey : displayName
            ], completion: { (error) in
            if let error = error {
              self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
            } 
          })
        self?.dismiss(animated: true)
        self?.navigationItem.rightBarButtonItem?.isEnabled = true
      }
    }
  }
  
  @IBAction func profileImageButtonPressed() {
    var actionTitles = [String]()
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      actionTitles = ["Photo Library", "Camera"]
    } else {
      actionTitles = ["Photo Library"]
    }
    showActionSheet(title: nil, message: nil, actionTitles: actionTitles, handlers: [{ [unowned self] photoLibraryAction in
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true)
      }, { cameraAction in
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true)
      }
    ])
  }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      print("original image not available")
      return
    }
    let size = CGSize(width: 500, height: 500)
    let resizedImage = Toucan.Resize.resizeImage(originalImage, size: size)
    selectedImage = resizedImage
    profileImageViewButton.setImage(resizedImage, for: .normal)
    dismiss(animated: true)
  }
}
