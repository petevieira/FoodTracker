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
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  weak var delegate: AddItemViewControllerDelegate?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.addItemViewControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
    let item = ChecklistItem()
    item.text = textField.text!
    item.checked = false

    delegate?.addItemViewController(controller: self,
                                    didFinishAddingItem: item)
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
