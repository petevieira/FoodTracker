//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Peter Vieira on 10/25/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate,
  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  // MARK: Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var ratingControl: RatingControl!
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
        photoImageView.image = meal.photo
        ratingControl.rating = meal.rating
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
  
  // MARK: UIImagePickerControllerDelegate
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // Dismiss the picker if the user canceled.
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    // The info dictionary contains multiple representations of the image, and this uses the original.
    let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage

    // Set photoImageView to display the selected image.
    photoImageView.image = selectedImage

    // Dismiss the picker.
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Navigation
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  // this method lets you configure a view controller before it's presented
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if saveButton === sender as? UIBarButtonItem {
      let name = nameTextField.text ?? ""
      let photo = photoImageView.image
      let rating = ratingControl.rating
      // set the meal to be passed to the MealTableViewController after the unwind seque
      meal = Meal(name: name, photo: photo, rating: rating)
    }
  }
  
  // MARK: Actions
  @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
    // hide the keyboard
    nameTextField.resignFirstResponder()

    // UIImagePickerController is a view controller that lets a user pick media from their photo library.
    let imagePickerController = UIImagePickerController()
    
    // Only allow photos to be picked, not taken.
    imagePickerController.sourceType = .photoLibrary

    present(imagePickerController, animated: true, completion: nil)

    // Make sure ViewController is notified when the user picks an image.
    imagePickerController.delegate = self
  }

}

