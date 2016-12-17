//
//  CheclistViewController.swift
//  Checklists
//
//  Created by Peter Vieira on 11/17/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

  // MARK: Member Variables
  var rows: [ChecklistItem]
  var checklist: Checklist!

  required init?(coder aDecoder: NSCoder) {
    self.rows = [ChecklistItem]()

    super.init(coder: aDecoder)
    self.loadChecklistItems()
  }
  
  // MARK: Overrided Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    title = self.checklist.name
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return self.rows.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath as IndexPath)
    let item = self.rows[indexPath.row]

    self.configureTextForCell(cell: cell, withChecklistItem: item)
    self.configureCheckmarkForCell(cell: cell, withChecklistItem: item)

    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = self.rows[indexPath.row]
      item.toggleChecked()

      self.configureCheckmarkForCell(cell: cell, withChecklistItem: item)
    }
    tableView.deselectRow(at: indexPath, animated: true)
    self.saveCheckListItems()
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {

    self.rows.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
    self.saveCheckListItems()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ItemDetailViewController
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ItemDetailViewController
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
    let newRowIndex = self.rows.count
    let item = ChecklistItem()
    item.text = "I am a new row"
    item.checked = false
    self.rows.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  // MARK: ItemDetailViewControllerDelegate Implementations
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {

    // Get location of new item in tableview
    let newRowIndex = self.rows.count

    // Add item to rows data array
    self.rows.append(item)

    // Add row to tableview
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)

    // Close the ItemDetailViewController view
    dismiss(animated: true, completion: nil)
    self.saveCheckListItems()
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
    if let index = self.rows.index(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        self.configureTextForCell(cell: cell, withChecklistItem: item)
      }
    }
    dismiss(animated: true, completion: nil)
    self.saveCheckListItems()
  }
  
  // MARK: Saving and Loading Data
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    return paths[0]
  }
  
  func dataFilePath() -> String {
    let directory = self.documentsDirectory() as NSString
    return directory.appendingPathComponent("Checklist.plist")
  }
  
  func saveCheckListItems() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.encode(self.rows, forKey: "ChecklistItems")
    archiver.finishEncoding()
    data.write(toFile: dataFilePath(), atomically: true)
  }
  
  func loadChecklistItems() {
    let path = self.dataFilePath() // Step 1
    if FileManager.default.fileExists(atPath: path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
        rows = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
        unarchiver.finishDecoding()
      }
    }
  }
}

