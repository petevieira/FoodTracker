//
//  Meal.swift
//  FoodTracker
//
//  Created by Peter Vieira on 10/30/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

class Meal {
  // MARK: Properties
  
  var name: String
  var photo: UIImage?
  var rating: Int

  // MARK: Initializer
  init?(name: String, photo: UIImage?, rating: Int) {
    self.name = name
    self.photo = photo
    self.rating = rating
    
    // Initializer should fail for invalid values of name and rating
    if name.isEmpty || rating < 0 || rating > 5 {
      return nil
    }
  }

}
