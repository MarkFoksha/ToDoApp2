//
//  TaskListViewControllerTests.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 17.01.2024.
//

import XCTest
@testable import ToDoApp2

final class TaskListViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTableViewNotNillWhenViewIsLoaded() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        
        let sut = vc as! TaskListViewController
        sut.loadViewIfNeeded()
         
        XCTAssertNotNil(sut.tableView)
    }
    

}
