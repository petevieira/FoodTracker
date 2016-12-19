//
//  CheclistViewController.swift
//  Checklists
//
//  Created by Peter Vieira on 11/17/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

/**
    Subclass of UITableViewController that controls a checklist view.
    A checklist view displays a list of items in that checklist.
    It conforms to the ItemDetailViewControllerDelegate protocol in order
    to interact with the ItemDetailViewController class appropriately.
 */
class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

  // MARK: Member Variables
  var items: [ChecklistItem] // Array of Checklist items
  var checklist: Checklist! // Checklist instance being controlled

  required init?(coder aDecoder: NSCoder) {
    self.items = [ChecklistItem]()

    super.init(coder: aDecoder)
    self.loadChecklistItems()
  }
  
  // MARK: Overrided Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    /* Set the title at the top of the Checklist TableView */
    title = self.checklist.name
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    /* Dispose of any resources that can be recreated. */
  }

  /**
      Returns the number of rows in a section.
   */
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }

  /**
      Returns a reusable ChecklistItem cell at the specified index path, by
      taking it from an offscreen cell, in order to create the view of a cell.
      The cell gets filled in based on the properties of the item at the
      specified index in the items array.
   */
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    /* Create a new cell or get a reusable cell from offscreen */
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath as IndexPath)
    /* Get the item at the specified index in the items array */
    let item = self.items[indexPath.row]

    /* Configure the cell's text based on the item's */
    self.configureTextForCell(cell: cell, withChecklistItem: item)
    /* Configure the cell's checkmark based on the item's */
    self.configureCheckmarkForCell(cell: cell, withChecklistItem: item)

    /* Return the configured cell to the TableView for display */
    return cell
  }

  /**
     Tableview tells this class that a row has been selected.
     If there's a valid cell at the selected row, get the item associated
     with that cell and toggle its checkmark.
   */
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    /* Get the cell at the selected row */
    if let cell = tableView.cellForRow(at: indexPath) {
      /* Get the item associated with the cell */
      let item = self.items[indexPath.row]
      /* Toggle the checkmark */
      item.toggleChecked()
      self.configureCheckmarkForCell(cell: cell, withChecklistItem: item)
    }
    /* Deselect the row */
    tableView.deselectRow(at: indexPath, animated: true)
    self.saveCheckListItems()
  }

  /**
     Tableview asks self to commit the deletion in the specified row
     in self.
   */
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    /* Delete the item in the items array at the specified row */
    self.items.remove(at: indexPath.row)
    /* Delete the tableview row at the index */
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
    self.saveCheckListItems()
  }
  
  /**
     Prepares for the triggered segue
   */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    /* Prepares for a segue to the AddItem detail view */
    if segue.identifier == "AddItem" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ItemDetailViewController
      controller.delegate = self
      /* Prepares for a segue to the EditItem detail view */
    } else if segue.identifier == "EditItem" {
      /* Get the controller inside the navigation controller that we are segueing to */
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ItemDetailViewController
      controller.delegate = self

      /* Get the item associated with the row in the tableview that triggered the segue
         since that's the item to add or edit */
      if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = self.items[indexPath.row]
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
  /* Callback for the "+" button. Create a new Checklist item,
     append it to the array of items and  */
  @IBAction func addItem(sender: UIBarButtonItem) {
    let newRowIndex = self.items.count
    let item = ChecklistItem()
    item.text = "I am a new row"
    item.checked = false
    self.items.append(item)
    
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
    let newRowIndex = self.items.count

    // Add item to rows data array
    self.items.append(item)

    // Add row to tableview
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)

    // Close the ItemDetailViewController view
    dismiss(animated: true, completion: nil)
    self.saveCheckListItems()
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
    if let index = self.items.index(of: item) {
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
    archiver.encode(self.items, forKey: "ChecklistItems")
    archiver.finishEncoding()
    data.write(toFile: dataFilePath(), atomically: true)
  }
  
  func loadChecklistItems() {
    let path = self.dataFilePath() // Step 1
    if FileManager.default.fileExists(atPath: path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
        items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
        unarchiver.finishDecoding()
      }
    }
  }
}

