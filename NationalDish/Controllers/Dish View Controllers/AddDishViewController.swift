//
//  AddDishViewController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/8/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class AddDishViewController: UIViewController {
  
  @IBOutlet weak var dishDescriptionTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTextView()
  }
  
  private func configureTextView() {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
    let cameraBarItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: nil)
    let photoLibraryBarItem = UIBarButtonItem(title: "Photo Library", style: .plain, target: self, action: nil)
    let flexibleSpaceBarItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    toolbar.items = [cameraBarItem, flexibleSpaceBarItem, photoLibraryBarItem]
    dishDescriptionTextView.inputAccessoryView = toolbar
    dishDescriptionTextView.delegate = self
    dishDescriptionTextView.textColor = .lightGray
    dishDescriptionTextView.text = Constants.DishDescriptionPlaceholder
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func addDishButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
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
