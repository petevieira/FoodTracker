//
//  Meal.swift
//  FoodTracker
//
//  Created by Peter Vieira on 10/30/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

// Meal object when gets passed around and 
// visualized in the tableviewcell and tableviewcontroller
class Meal: NSObject, NSCoding {
  // MARK: Properties
  var name: String
  
  // MARK: Archiving Paths
  static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.standardizedFileURL.appendingPathComponent("meals")
  
  // MARK: Types
  struct PropertyKey {
    static let nameKey = "name"
  }
  

  // MARK: Initializer
  init?(name: String) {
    self.name = name
    
    super.init()
    
    // Initializer should fail for invalid values of name and rating
    if name.isEmpty {
      return nil
    }
  }

  // MARK: NSCoding
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: PropertyKey.nameKey)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
    
    // Must call designated initializer
    self.init(name: name)
  }
}
