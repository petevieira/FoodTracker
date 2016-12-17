//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Peter Vieira on 12/6/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(controller: ListDetailViewController)
  
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist)
  
  func listDetailViewController(controller: ListDetailViewController,
                                didFinishEditingChecklist checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklist = checklistToEdit {
      title = "Edit Checklist"
      textField.text = checklist.name
      doneBarButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      delegate?.listDetailViewController(controller: self, didFinishEditingChecklist: checklist)
    } else {
      let checklist  = Checklist(name: textField.text!)
      delegate?.listDetailViewController(controller: self, didFinishAddingChecklist: checklist)
    }
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text! as NSString
    
    let newText = oldText.replacingCharacters(in: range, with: string)
    
    doneBarButton.isEnabled = !newText.isEmpty
    
    return true
  }
  
  func textField(textField: UITextField,
                 shouldChangeCharactersInRange range: NSRange,
                 replacementString string: String) -> Bool {
    let oldText: NSString = textField.text! as NSString
    
    let newText = oldText.replacingCharacters(in: range, with: string)
    
    doneBarButton.isEnabled = !newText.isEmpty
    
    return true
  }

}



