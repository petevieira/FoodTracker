//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Peter Vieira on 10/29/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import UIKit

class RatingControl: UIView {

  // MARK: Properties
  var rating = 0 {
    didSet {
      setNeedsLayout()
    }
  }
  var ratingButtons = [UIButton]()
  let spacing = 5
  let numStars = 5
  let ratingControlHeight = 44
  
  
  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    self.frame.size.height = CGFloat(ratingControlHeight)
    let filledStarImage = UIImage(named: "filledStar")
    let emptyStarImage = UIImage(named: "emptyStar")
    
    for _ in 0..<numStars {
      let button = UIButton()
      button.setImage(emptyStarImage, for: .normal)
      button.setImage(filledStarImage, for: .selected)
      button.setImage(filledStarImage, for: [.highlighted, .selected])
      button.adjustsImageWhenHighlighted = false

      button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)),
                       for: .touchDown)
      ratingButtons += [button]
      addSubview(button)
    }
  }
  
  override func layoutSubviews() {
    // set the button's width and height to a square the size of the frame's height
    let buttonSize = 44 //Int(frame.size.height)
    var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)

    // offset each buttons origin by the width plus spacing
    for (index, button) in ratingButtons.enumerated() {
      buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
      button.frame = buttonFrame
    }
    
    updateButtonSelectionStates()
  }

  override public var intrinsicContentSize: CGSize {
    let buttonSize = Int(frame.size.height)
    let width = (buttonSize * numStars) + (spacing * (numStars - 1))

    return CGSize(width: width, height: buttonSize)
  }
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  // MARK: Button Action
  func ratingButtonTapped(button: UIButton) {
    rating = ratingButtons.index(of: button)! + 1
    
    updateButtonSelectionStates()
  }
  
  func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerated() {
      // If the index of the button is less than the rating, that
      // button should be selected
      button.isSelected = index < rating
    }
  }
}
