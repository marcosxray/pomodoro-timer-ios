//
//  PomodoroTimerUITests.swift
//  PomodoroTimerUITests
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import XCTest

// This value should have twice the amount of PTConstants.initialTaskTime
// in this case, I'm considering that PTConstants.initialTaskTime is set to 5
let timeout: Double = 10

class PomodoroTimerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testStopedTimer() {
        let app = XCUIApplication()
        app.buttons["PLAY"].tap()
        app.buttons["STOP"].tap()
        app.tabBars.buttons["History"].tap()
        
        let stoppedCellElement = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["stopped"]
        XCTAssert(stoppedCellElement.exists)
    }
    
    func testOneFullTaskTimer() {
        let app = XCUIApplication()
        app.buttons["PLAY"].tap()
        app.tabBars.buttons["History"].tap()
        
        let finishedCellElement = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["finished"]

        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: finishedCellElement, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
}
