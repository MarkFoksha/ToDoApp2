//
//  ToDoApp2UITests.swift
//  ToDoApp2UITests
//
//  Created by Марк Фокша on 04.12.2023.
//

import XCTest

final class ToDoApp2UITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments.append("--UITesting")
        app.launch()
        
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func setUpElements() {
        app.navigationBars["ToDoApp2.TaskListView"].buttons["Add"].tap()
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Foo")
        
        app.textFields["Location"].tap()
        app.textFields["Location"].typeText("Bar")
        
        app.textFields["Date"].tap()
        app.textFields["Date"].typeText("01.01.24")
    }

    func testExample() throws {
        XCTAssertTrue(app.isOnMainView)

        setUpElements()
        
        XCTAssertFalse(app.isOnMainView)
        
        app/*@START_MENU_TOKEN@*/.staticTexts["save"]/*[[".buttons[\"save\"].staticTexts[\"save\"]",".staticTexts[\"save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.tables.staticTexts["Foo"].exists)
        XCTAssertTrue(app.tables.staticTexts["Bar"].exists)
        XCTAssertTrue(app.tables.staticTexts["01.01.24"].exists)
    }
    
    func testWhenCellIsSwipedLeftDoneButtonIsAppeared() {
        XCTAssertTrue(app.isOnMainView)

        setUpElements()
        
        XCTAssertFalse(app.isOnMainView)
        app/*@START_MENU_TOKEN@*/.staticTexts["save"]/*[[".buttons[\"save\"].staticTexts[\"save\"]",".staticTexts[\"save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.tables.staticTexts["Foo"].exists)
        XCTAssertTrue(app.tables.staticTexts["Bar"].exists)
        XCTAssertTrue(app.tables.staticTexts["01.01.24"].exists)
        
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).swipeLeft()
        tablesQuery.element(boundBy: 0).buttons["Done"].tap()
        
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "date").label, "")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIApplication {
    var isOnMainView: Bool {
        return otherElements["mainView"].exists
    }
}
