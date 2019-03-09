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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let indexPath = tableView.indexPathForSelectedRow,
      let editDishViewController = segue.destination as? EditDishViewController else {
        fatalError("prepare for segue nil")
    }
  }
}

extension NationalDishesController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dishes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath)
    let dish = dishes[indexPath.row]
    cell.imageView?.kf.setImage(with: URL(string: dish.imageURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
    return cell
  }
}

extension NationalDishesController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

