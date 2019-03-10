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
  
  public var dish: Dish!
  public var displayName: String? 
  
  // TODO: setup outlets to show the dish image, display name for user who created the dish,
  // TODO: also the dish description
  // TODO: embed in a scroll view to account for a dynamic desription name
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "\(dish.country) - \(dish.dishDescription)"
    upadateUI()
  }
  
  private func upadateUI() {
    dishImageView.kf.setImage(with: URL(string: dish.imageURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
    displayNameLabel.text = (displayName ?? "username")
    countryNameLabel.text = dish.country
    dishDescriptionLabel.text = dish.dishDescription
  }
  
  // TODO: add a more info button which presents an action sheet that does the following:
  // TODO: user should be able to save image to device
  // TODO: user should be able to delete the dish if they created it
  // TODO: user should be able to edit the dish if they created it
  
  @IBAction func moreInfoButtonPressed(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let saveImageAction = UIAlertAction(title: "Save Image", style: .default) { (action) in
      
    }
    let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
      
    }
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] (action) in
      self.confirmDeletionActionSheet(handler: { (action) in
        self.executeDelete()
      })
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(saveImageAction)
    alertController.addAction(editAction)
    alertController.addAction(deleteAction)
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
}
