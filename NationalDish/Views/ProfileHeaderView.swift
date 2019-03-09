//
//  ProfileHeaderView.swift
//  NationalDish
//
//  Created by Alex Paul on 3/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

// TODO: use custom delegation to signal actions from edit and sign out buttons 

class ProfileHeaderView: UIView {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var profileImageView: CircularImageView!
  @IBOutlet weak var displayNameLabel: UILabel!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var signOutButton: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
  }
  @IBAction func signOutButtonPressed(_ sender: UIButton) {
    
  }
  
  @IBAction func editButtonPressed(_ sender: UIButton) {
    
  }
}
