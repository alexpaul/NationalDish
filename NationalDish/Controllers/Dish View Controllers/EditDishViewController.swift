//
//  EditDishViewController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/8/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class EditDishViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // TODO: should be able to edit the following:
  // TODO: can edit the dishDescription
  // TODO: can edit the country
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func saveEditButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
}
