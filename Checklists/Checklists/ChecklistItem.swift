//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Peter Vieira on 11/21/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
  var text = ""
  var checked = false
  
  func toggleChecked() {
    checked = !checked
  }
}
