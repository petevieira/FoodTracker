//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Peter Vieira on 10/25/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

// Controls what's displayed in the MealView scene (New Meal Scene)
class MealViewController: UIViewController, UITextFieldDelegate,
  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  // MARK: Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var saveButton: UIBarButtonItem!

  /*
   This value is either passed by 'MealTableViewController' in
   'prepareForSegue(_:sender:)' or constructed as part of adding a new meal
   */
  var meal: Meal? // optional property. Can be nil at any time

    override func viewDidLoad() {
      super.viewDidLoad()

      // set the text field's delegate to be this class
      nameTextField.delegate = self
    
      // Set up views if editing an existing meal
      if let meal = meal {
        navigationItem.title = meal.name
        nameTextField.text = meal.name
      }
    
      // Enable the Save button  only if the text field has a valid meal name
      checkValidMealName()
  }
  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // Disable the save button while editing
    saveButton.isEnabled = false
  }
  
  func checkValidMealName() {
    // Disable the Save button if the text field is empty
    let text = nameTextField.text ?? ""
    saveButton.isEnabled = !text.isEmpty
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    checkValidMealName()
    navigationItem.title = textField.text

  }
  
  // MARK: Navigation
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
    let isPresentingInAddMealMode = presentingViewController is UINavigationController
    if isPresentingInAddMealMode {
      dismiss(animated: true, completion: nil)
    } else {
      navigationController!.popViewController(animated: true)
    }

  }
  
  // this method lets you configure a view controller before it's presented
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if saveButton === sender as? UIBarButtonItem {
      let name = nameTextField.text ?? ""
      // set the meal to be passed to the MealTableViewController after the unwind seque
      meal = Meal(name: name)
    }
  }
  
  // MARK: Actions

}

