//
//  ProfileViewController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/7/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private lazy var profileHeaderView: ProfileHeaderView = {
    let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
    return headerView
  }()
  private let authservice = AppDelegate.authservice
  
  // TODO: create a variable called "dishes" that will be the data for the table view: see logic in (NationalDishesController)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    updateProfileUI()
  }
  
  private func configureTableView() {
    tableView.tableHeaderView = profileHeaderView
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "DishCell")
  }
  
  private func updateProfileUI() {
    guard let user = authservice.getCurrentUser() else {
      print("no logged user")
      return
    }
    profileHeaderView.displayNameLabel.text = "@" + (user.displayName ?? "rogueAgent")
  }
  
  // TODO: write a function to query firestore database for only the current user's posted dishes
}

extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: return the count from the current user's dishes
    return 10
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath) as? DishCell else {
      fatalError("DishCell not found")
    }
    // TODO: setup the cell
    // TODO: displayName
    // TODO: country
    // TODO: dishDescription
    // TODO: dish image
    // see cellForRow in (NationalDishesController)
    return cell
  }
}

extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.DishCellHeight
  }
}

// TODO: implement sign out from firebase

// TODO: edit profile
