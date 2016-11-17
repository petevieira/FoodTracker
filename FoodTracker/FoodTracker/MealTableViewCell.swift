//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Peter Vieira on 10/30/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

// One of the table view cells
class MealTableViewCell: UITableViewCell {

  // MARK: Properties
  @IBOutlet weak var nameLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
