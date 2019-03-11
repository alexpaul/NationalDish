//
//  ViewController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/7/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class NationalDishesController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var dishes = [Dish]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  private var listener: ListenerRegistration!
  private var authservice = AppDelegate.authservice
  private lazy var refreshControl: UIRefreshControl = {
    let rc = UIRefreshControl()
    tableView.refreshControl = rc
    rc.addTarget(self, action: #selector(fetchNationalDishes), for: .valueChanged)
    return rc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "DishCell")
    authservice.authserviceSignOutDelegate = self
    fetchNationalDishes()
  }
  
  @objc private func fetchNationalDishes() {
    refreshControl.beginRefreshing()
    listener = DBService.firestoreDB
      .collection(DishesCollectionKeys.CollectionKey)
      .addSnapshotListener { [weak self] (snapshot, error) in
        if let error = error {
          print("failed to fetch dishes with error: \(error.localizedDescription)")
        } else if let snapshot = snapshot {
          self?.dishes = snapshot.documents.map { Dish(dict: $0.data()) }
                                           .sorted { $0.createdDate.date() > $1.createdDate.date() }
        }
        DispatchQueue.main.async {
          self?.refreshControl.endRefreshing()
        }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Dish Details" {
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

extension NationalDishesController: UITableViewDataSource {
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
    fetchDishCreator(userId: dish.userId, cell: cell, dish: dish)
    return cell
  }
  
  private func fetchDishCreator(userId: String, cell: DishCell, dish: Dish) {
    DBService.fetchDishCreator(userId: userId) { (error, dishCreator) in
      if let error = error {
        print("failed to fetch dish creator with error: \(error.localizedDescription)")
      } else if let dishCreator = dishCreator {
        cell.displayNameLabel.text = "@" + dishCreator.displayName
      }
    }
  }
}

extension NationalDishesController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.DishCellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "Show Dish Details", sender: indexPath)
  }
}

extension NationalDishesController: AuthServiceSignOutDelegate {
  func didSignOut(_ authservice: AuthService) {
    listener.remove()
    showLoginView()
  }
  func didSignOutWithError(_ authservice: AuthService, error: Error) {}
}
