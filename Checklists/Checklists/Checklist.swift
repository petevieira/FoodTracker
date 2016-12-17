//
//  Checklist.swift
//  Checklists
//
//  Created by Peter Vieira on 12/4/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

class Checklist: NSObject {
  var name = ""
  
  init(name: String) {
    self.name = name
    super.init()
  }
}
