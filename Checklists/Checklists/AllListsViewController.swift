//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Peter Vieira on 11/30/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController,
                              ListDetailViewControllerDelegate {

  var lists: [Checklist]
  
  required init?(coder aDecoder: NSCoder) {
    lists = [Checklist]()
    
    super.init(coder: aDecoder)
    
    var list = Checklist(name: "Birthdays")
    self.lists.append(list)
    
    list = Checklist(name: "Groceries")
    self.lists.append(list)
    
    list = Checklist(name: "Cool Apps")
    self.lists.append(list)
    
    list = Checklist(name: "To Do")
    self.lists.append(list)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return lists.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = cellForTableView(tableView)
    
    // Configure the cell...
    let checklist = self.lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .detailDisclosureButton

    return cell
  }
  
  func cellForTableView(_ tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
      return cell
    } else {
      return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let checklist = lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = sender as! Checklist
    } else if segue.identifier == "AddChecklist" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ListDetailViewController
      controller.delegate = self
      controller.checklistToEdit = nil
    }
  }
 
  func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
    // Got a new checklist, so add it to our list of checklists
    let newRowIndex = self.lists.count
    lists.append(checklist)
    
    // Now add the associated cell to the tableview
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    
    dismiss(animated: true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
    if let index = lists.index(of: checklist) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        cell.textLabel!.text = checklist.name
      }
    }
    dismiss(animated: true, completion: nil)
  }
}

