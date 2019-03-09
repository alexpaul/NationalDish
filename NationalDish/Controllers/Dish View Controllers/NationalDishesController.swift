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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
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
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath)
    return cell
  }
  
  private func fetchDishCreator(userId: String, cell: UITableViewCell, dish: Dish) {
    DBService.firestoreDB
      .collection(NDUsersCollectionKeys.CollectionKey)
      .whereField(NDUsersCollectionKeys.UserIdKey, isEqualTo: userId)
      .getDocuments { (snapshot, error) in
        if let error = error {
          print("failed to fetch dish creator with error: \(error.localizedDescription)")
        } else if let snapshot = snapshot?.documents.first {
          let user = NDUser(dict: snapshot.data())
          cell.textLabel?.text = "\(user.displayName), \(dish.country)"
          cell.detailTextLabel?.text = user.displayName
        }
    }
    
  }
}

extension NationalDishesController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

