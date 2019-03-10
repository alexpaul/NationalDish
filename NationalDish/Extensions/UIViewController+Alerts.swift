//
//  UIViewController+Alerts.swift
//  NationalDish
//
//  Created by Alex Paul on 3/7/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

extension UIViewController {
  public func showAlert(title: String?, message: String?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  public func showAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler) 
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  public func confirmDeletionActionSheet(handler: ((UIAlertAction) -> Void)?) {
    let alertController = UIAlertController(title: "Are you sure?", message: "Deleting this activity will erase it permanently", preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handler)
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true)
  }
}
