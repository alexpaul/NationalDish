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
  private lazy var dishCreatorCache: NSCache<NSString, NDUser> = {
    let cache = NSCache<NSString, NDUser>()
    cache.totalCostLimit = 10 * 1024 * 1024
    cache.countLimit = 100
    return cache
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
    // creating a listener
    // 1. get database reference DBService.firestoreDB
    // 2. which collection do you want to observe (listen) to?
    // 3. add listener (addSnapshotListener)
    
    refreshControl.beginRefreshing()
    listener = DBService.firestoreDB
      .collection(DishesCollectionKeys.CollectionKey)
      // always observes firebase in real-time for data changes
      // [weak self] - closure list, breaks potential memory leaks
      // [weak self] - breaks strong retain cycles
      // use [weak self] when closure may be around longer than view controller
      // use [unowned self] when view controller is GURANTEED to be around longer
      // than closure
      // if we don't user weak or unowned it will be strong by default which will lead to a memory leak
      // Apple Docs: https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
      .addSnapshotListener { [weak self] (snapshot, error) in
        if let error = error {
          print("failed to fetch dishes with error: \(error.localizedDescription)")
        } else if let snapshot = snapshot {
          // anytime there is a modified change to the database our table view updates
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
    cell.selectionStyle = .none
    cell.countryLabel.text = dish.country
    cell.dishDescriptionLabel.text = dish.dishDescription
    cell.displayNameLabel.text = ""
    cell.dishImageView.kf.indicatorType = .activity
    cell.dishImageView.kf.setImage(with: URL(string: dish.imageURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
    if let dishCreator = dishCreatorCache.object(forKey: dish.userId as NSString) {
      cell.displayNameLabel.text = "@" + dishCreator.displayName
    } else {
      fetchDishCreator(userId: dish.userId, cell: cell, dish: dish)
    }
    return cell
  }
  
  private func fetchDishCreator(userId: String, cell: DishCell, dish: Dish) {
    DBService.fetchUser(userId: userId) { [weak self] (error, dishCreator) in
      if let error = error {
        print("failed to fetch dish creator with error: \(error.localizedDescription)")
      } else if let dishCreator = dishCreator {
        cell.displayNameLabel.text = "@" + dishCreator.displayName
        self?.dishCreatorCache.setObject(dishCreator, forKey: dishCreator.userId as NSString)
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
