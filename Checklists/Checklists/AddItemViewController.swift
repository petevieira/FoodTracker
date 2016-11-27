//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Peter Vieira on 11/22/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemViewControllerDelegate: class {
  func addItemViewControllerDidCancel(controller: AddItemViewController)
  func addItemViewController(controller: AddItemViewController,
                             didFinishAddingItem item: ChecklistItem)
  func addItemViewController(controller: AddItemViewController,
                             didFinishEditingItem item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  weak var delegate: AddItemViewControllerDelegate?
  var itemToEdit: ChecklistItem?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let item  = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneBarButton.isEnabled = true
    }
  }
  @IBAction func cancel() {
    delegate?.addItemViewControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text!
      delegate?.addItemViewController(controller: self, didFinishEditingItem: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text!
      item.checked = false

      delegate?.addItemViewController(controller: self,
                                      didFinishAddingItem: item)
    }
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {

    let oldText: NSString = textField.text! as NSString

    let newText = oldText.replacingCharacters(in: range, with: string)

    doneBarButton.isEnabled = !newText.isEmpty

    return true
  }
}
