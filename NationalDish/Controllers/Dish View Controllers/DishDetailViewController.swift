//
//  DishDetailViewController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController {
  @IBOutlet weak var dishImageView: UIImageView!
  @IBOutlet weak var displayNameLabel: UILabel!
  @IBOutlet weak var countryNameLabel: UILabel!
  @IBOutlet weak var dishDescriptionLabel: UILabel!
  
  private let authservice = AppDelegate.authservice
  
  public var dish: Dish!
  public var displayName: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    upadateUI()
  }
  
  private func upadateUI() {
    navigationItem.title = "\(dish.country) - \(dish.dishDescription)"
    dishImageView.kf.setImage(with: URL(string: dish.imageURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
    displayNameLabel.text = (displayName ?? "username")
    countryNameLabel.text = dish.country
    dishDescriptionLabel.text = dish.dishDescription
  }
  
  // setting up unwind segue
  // step 1: create unwindFrom....function
  // writing this function in view controller unwinding to
  @IBAction func unwindFromEditDishView(segue: UIStoryboardSegue) {
    let editVC = segue.source as! EditDishViewController
    countryNameLabel.text = editVC.countryTextField.text
    dishDescriptionLabel.text = editVC.dishDescriptionTextView.text
  }
  
  @IBAction func moreInfoButtonPressed(_ sender: UIBarButtonItem) {
    guard let user = authservice.getCurrentUser() else {
      print("no logged user")
      return
    }
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let saveImageAction = UIAlertAction(title: "Save Image", style: .default) { [unowned self] (action) in
      if let image = self.dishImageView.image {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
      }
    }
    let editAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] (action) in
      self.showEditView()
    }
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] (action) in
      self.confirmDeletionActionSheet(handler: { (action) in
        self.executeDelete()
      })
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(saveImageAction)
    if user.uid == dish.userId {
      alertController.addAction(editAction)
      alertController.addAction(deleteAction)
    }
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
  
  private func executeDelete() {
    DBService.deleteDish(dish: dish) { [weak self] (error) in
      if let error = error {
        self?.showAlert(title: "Error deleting dish", message: error.localizedDescription)
      } else {
        self?.showAlert(title: "Deleted successfully", message: nil, handler: { (action) in
          self?.navigationController?.popViewController(animated: true)
        })
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Edit Dish" {
      guard let navController = segue.destination as? UINavigationController,
        let editVC = navController.viewControllers.first as? EditDishViewController else {
          fatalError("failed to segue to editVC")
      }
      editVC.dish = dish
    }
  }
  
  private func showEditView() {
    performSegue(withIdentifier: "Show Edit Dish", sender: nil)
  }
}
