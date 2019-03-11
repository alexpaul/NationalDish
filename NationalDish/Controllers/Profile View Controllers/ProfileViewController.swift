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
  private var dishes = [Dish]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    profileHeaderView.delegate = self
    fetchUsersDishes()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
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
    DBService.fetchUser(userId: user.uid) { [weak self] (error, user) in
      if let _ = error {
        self?.showAlert(title: "Error fetching account info", message: error?.localizedDescription)
      } else if let user = user {
        self?.profileHeaderView.displayNameLabel.text = "@" + user.displayName
        guard let photoURL = user.photoURL,
          !photoURL.isEmpty else {
            return
        }
        self?.profileHeaderView.profileImageView.kf.setImage(with: URL(string: photoURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
      }
    }
  }
  
  private func fetchUsersDishes() {
    guard let user = authservice.getCurrentUser() else {
      print("no logged user")
      return
    }
    let _ = DBService.firestoreDB
      .collection(DishesCollectionKeys.CollectionKey)
      .whereField(DishesCollectionKeys.UserIdKey, isEqualTo: user.uid)
      .addSnapshotListener { [weak self] (snapshot, error) in
        if let error = error {
          self?.showAlert(title: "Error fetching dishes", message: error.localizedDescription)
        } else if let snapshot = snapshot {
          self?.dishes = snapshot.documents.map { Dish(dict: $0.data()) }
        }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Edit Profile" {
      guard let navController = segue.destination as? UINavigationController,
        let editProfileVC = navController.viewControllers.first as? EditProfileViewController
      else {
        fatalError("editProfileVC not found")
      }
      editProfileVC.profileImage = profileHeaderView.profileImageView.image
      editProfileVC.displayName = profileHeaderView.displayNameLabel.text
    } else if segue.identifier == "Show Dish Details" {
      guard let indexPath = sender as? IndexPath,
        let cell = tableView.cellForRow(at: indexPath) as? DishCell,
        let dishDVC = segue.destination as? DishDetailViewController else {
          fatalError("cannot segue to dishDVC")
      }
      let dish = dishes[indexPath.row]
      dishDVC.displayName = cell.displayNameLabel.text
      dishDVC.dish = dish
    }
  }
}

extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dishes.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath) as? DishCell else {
      fatalError("DishCell not found")
    }
    let dish = dishes[indexPath.row]
    cell.countryLabel.text = dish.country
    cell.dishDescriptionLabel.text = dish.dishDescription
    cell.displayNameLabel.text = ""
    cell.dishImageView.kf.setImage(with: URL(string: dish.imageURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
    return cell
  }
}

extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "Show Dish Details", sender: indexPath)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.DishCellHeight
  }
}

extension ProfileViewController: ProfileHeaderViewDelegate {
  func willSignOut(_ profileHeaderView: ProfileHeaderView) {
    authservice.signOutAccount()
  }
  func willEditProfile(_ profileHeaderView: ProfileHeaderView) {
    performSegue(withIdentifier: "Show Edit Profile", sender: nil)
  }
}
