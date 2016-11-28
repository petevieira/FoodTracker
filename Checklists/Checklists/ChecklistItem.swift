//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Peter Vieira on 11/21/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  
  override init() {
    super.init()
  }

  func toggleChecked() {
    checked = !checked
  }
  
  // MARK: NSCoding Protocol Functions
  required init?(coder aDecoder: NSCoder) {
    self.text = aDecoder.decodeObject(forKey: "Text") as! String
    self.checked = aDecoder.decodeBool(forKey: "Checked")
    super.init()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.text, forKey: "Text")
    aCoder.encode(self.checked, forKey: "Checked")
  }
}
