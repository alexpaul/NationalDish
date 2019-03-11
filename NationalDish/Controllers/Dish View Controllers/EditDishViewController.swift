//
//  EditDishViewController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/8/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class EditDishViewController: UIViewController {
  @IBOutlet weak var countryTextField: UITextField!
  @IBOutlet weak var dishDescriptionTextView: UITextView!
  
  public var dish: Dish!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  private func updateUI() {
    countryTextField.text = dish.country
    dishDescriptionTextView.text = dish.dishDescription
  }
    
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func saveEditButtonPressed(_ sender: UIBarButtonItem) {
    navigationItem.rightBarButtonItem?.isEnabled = false
    guard let country = countryTextField.text,
      !country.isEmpty,
      let dishDescription = dishDescriptionTextView.text,
      !dishDescription.isEmpty else {
        showAlert(title: "Missing Fields", message: "Country and Dish Description are Required")
        return
    }
    DBService.firestoreDB
      .collection(DishesCollectionKeys.CollectionKey)
      .document(dish.documentId)
      .updateData([DishesCollectionKeys.CountryKey        : country,
                   DishesCollectionKeys.DishDescritionKey : dishDescription
      ]) { [weak self] (error) in
        if let error = error {
          self?.showAlert(title: "Editing Error", message: error.localizedDescription)
        }
        self?.navigationItem.rightBarButtonItem?.isEnabled = true
        
        // setting up unwind segue
        // step 2: implement perform segue in view controller unwinding from
        // step 3: set segue identifier in storybaord
        // control drag from "yellow" storyboard icon over to "exit" icon and select
        // "unwindFrom....function" that refers to the function in the first view controller
        self?.performSegue(withIdentifier: "Unwind From Edit Dish", sender: self)
    }
  }
}
