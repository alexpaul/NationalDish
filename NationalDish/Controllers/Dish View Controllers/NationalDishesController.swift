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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "DishCell")
  }
  
  private func fetchNationalDishes() {
    listener = DBService.firestoreDB
      .collection(DishesCollectionKeys.CollectionKey)
      .addSnapshotListener { [weak self] (snapshot, error) in
        if let error = error {
          print("failed to fetch dishes with error: \(error.localizedDescription)")
        } else if let snapshot = snapshot {
          self?.dishes = snapshot.documents.map { Dish(dict: $0.data()) }
        }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    fetchNationalDishes()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    listener.remove()
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
    DBService.firestoreDB
      .collection(NDUsersCollectionKeys.CollectionKey)
      .whereField(NDUsersCollectionKeys.UserIdKey, isEqualTo: userId)
      .getDocuments { (snapshot, error) in
        if let error = error {
          print("failed to fetch dish creator with error: \(error.localizedDescription)")
        } else if let snapshot = snapshot?.documents.first {
          let user = NDUser(dict: snapshot.data())
          cell.displayNameLabel.text = "@" + user.displayName
        }
    }
  }
}

extension NationalDishesController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.DishCellHeight
  }
}

