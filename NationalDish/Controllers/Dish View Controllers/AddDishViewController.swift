//
//  AddDishViewController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/8/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import Toucan

class AddDishViewController: UIViewController {
  
  @IBOutlet weak var countryTextField: UITextField!
  @IBOutlet weak var dishDescriptionTextView: UITextView!
  @IBOutlet weak var dishImageView: UIImageView!
  
  private lazy var imagePickerController: UIImagePickerController = {
    let ip = UIImagePickerController()
    ip.delegate = self
    return ip
  }()
  private var selectedImage: UIImage?
  private var authservice = AppDelegate.authservice
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTextView()
  }
  
  private func configureTextView() {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
    let cameraBarItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                        target: self,
                                        action: #selector(cameraButtonPressed))
    let photoLibraryBarItem = UIBarButtonItem(title: "Photo Library",
                                              style: .plain,
                                              target: self,
                                              action: #selector(photoLibraryButtonPressed))
    let flexibleSpaceBarItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    toolbar.items = [cameraBarItem, flexibleSpaceBarItem, photoLibraryBarItem]
    dishDescriptionTextView.inputAccessoryView = toolbar
    dishDescriptionTextView.delegate = self
    dishDescriptionTextView.textColor = .lightGray
    dishDescriptionTextView.text = Constants.DishDescriptionPlaceholder
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
      cameraBarItem.isEnabled = false
    }
  }
  
  @objc func cameraButtonPressed() {
    imagePickerController.sourceType = .camera
    present(imagePickerController, animated: true)
  }
  
  @objc func photoLibraryButtonPressed() {
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true)
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func addDishButtonPressed(_ sender: UIBarButtonItem) {
    guard let country = countryTextField.text,
      !country.isEmpty,
      let dishDescription = dishDescriptionTextView.text,
      !dishDescription.isEmpty,
      let imageData = selectedImage?.jpegData(compressionQuality: 1.0) else {
        print("missing fields")
        return
    }
    guard let user = authservice.getCurrentUser() else {
      print("no logged user")
      return
    }
    let docRef = DBService.firestoreDB
                              .collection(DishesCollectionKeys.CollectionKey)
                              .document()
    StorageService.postImage(imageData: imageData,
                             imageName: Constants.DishImagePath + "\(user.uid)/\(docRef.documentID)") { [weak self] (error, imageURL) in
                              if let error = error {
                                print("fail to post iamge with error: \(error.localizedDescription)")
                              } else if let imageURL = imageURL {
                                print("image posted and recieved imageURL - post dish to database: \(imageURL)")
                                let dish = Dish(country: country,
                                                dishDescription: dishDescription,
                                                documentId: docRef.documentID,
                                                createdDate: Date.getISOTimestamp(),
                                                imageURL: imageURL.absoluteString,
                                                userId: user.uid)
                                DBService.postDish(dish: dish) { [weak self] error in
                                  if let error = error {
                                    self?.showAlert(title: "Posting Dish Error", message: error.localizedDescription)
                                  } else {
                                    self?.showAlert(title: "Dish Posted", message: "Looking forward to checking out your national dish") { action in
                                      self?.dismiss(animated: true)
                                    }
                                  }
                                }
                              }
    }
  }
}

extension AddDishViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == Constants.DishDescriptionPlaceholder {
      textView.text = ""
      textView.textColor = .black
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.text = Constants.DishDescriptionPlaceholder
      textView.textColor = .lightGray
    }
  }
}

extension AddDishViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      print("original image is nil")
      return
    }
    let resizedImage = Toucan.init(image: originalImage).resize(CGSize(width: 500, height: 500))
    selectedImage = resizedImage.image
    dishImageView.image = resizedImage.image
    dismiss(animated: true)
  }
}
