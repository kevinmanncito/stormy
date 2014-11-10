//
//  StormyTests.swift
//  StormyTests
//
//  Created by Kevin Mann on 11/5/14.
//  Copyright (c) 2014 Freedom Software. All rights reserved.
//

import UIKit
import XCTest

class StormyTests: XCTestCase {
    
    // Default initializer for testing
    let currentWeather = Current()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeString() {
        let timeString = "Nov 9, 2014, 9:13 PM"
        XCTAssertEqual(timeString, self.currentWeather.currentTime!, "make sure the time string is correctly converted from the unix timestamp")
    }
    
    func testIcon() {
        XCTAssertNotNil(self.currentWeather.icon, "make sure we got an actual image")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
