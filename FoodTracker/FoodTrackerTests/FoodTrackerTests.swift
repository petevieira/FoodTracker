//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Peter Vieira on 10/25/16.
//  Copyright © 2016 rapierevite. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  
  // MARK: FoodTracker Tests
  func testMealInitialization() {
    // success case
    let potentialItem = Meal(name: "Newest meal", photo: nil, rating: 5)
    XCTAssertNotNil(potentialItem)
    
    // failure cases
    let noName = Meal(name: "", photo: nil, rating: 3)
    XCTAssertNil(noName, "Empty name is invalid")
    
    let badRating = Meal(name: "Bad Rating", photo: nil, rating: -1)
    XCTAssertNil(badRating, "Negative rating is invalid")
    
    let tooHighRating = Meal(name: "Too High Rating", photo: nil, rating: 12)
    XCTAssertNil(tooHighRating, "Rating above 5 is invalid")
  }
    
}
