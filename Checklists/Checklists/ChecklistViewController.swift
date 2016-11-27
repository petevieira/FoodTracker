//
//  CheclistViewController.swift
//  Checklists
//
//  Created by Peter Vieira on 11/17/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {

  // MARK: Member Variables
  var rows: [ChecklistItem]

  required init?(coder aDecoder: NSCoder) {
    rows = [ChecklistItem]()

    let row0 = ChecklistItem()
    row0.text = "row 1"
    row0.checked = false
    rows.append(row0)

    let row1 = ChecklistItem()
    row1.text = "row 2"
    row1.checked = true
    rows.append(row1)
    
    super.init(coder: aDecoder)
  }

  // MARK: Overrided Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath as IndexPath)
    let item = self.rows[indexPath.row]

    configureTextForCell(cell: cell, withChecklistItem: item)
    configureCheckmarkForCell(cell: cell, withChecklistItem: item)

    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = self.rows[indexPath.row]
      item.toggleChecked()

      configureCheckmarkForCell(cell: cell, withChecklistItem: item)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {

    rows.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! AddItemViewController
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! AddItemViewController
      controller.delegate = self

      if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = self.rows[indexPath.row]
      }
    }
  }

  // MARK: Methods
  func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1001) as! UILabel
    
    if item.checked {
      label.text = "√"
    } else {
      label.text = ""
    }
  }
  
  func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }

  // MARK: Actions
  @IBAction func addItem() {
    let newRowIndex = rows.count
    let item = ChecklistItem()
    item.text = "I am a new row"
    item.checked = false
    rows.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  // MARK: AddItemViewControllerDelegate Implementations
  func addItemViewControllerDidCancel(controller: AddItemViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {

    // Get location of new item in tableview
    let newRowIndex = rows.count

    // Add item to rows data array
    rows.append(item)

    // Add row to tableview
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)

    // Close the AddItemViewController view
    dismiss(animated: true, completion: nil)
  }
  
  func addItemViewController(controller: AddItemViewController, didFinishEditingItem item: ChecklistItem) {
    if let index = rows.index(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureTextForCell(cell: cell, withChecklistItem: item)
      }
    }
    dismiss(animated: true, completion: nil)
  }
}

