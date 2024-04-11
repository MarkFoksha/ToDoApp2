//
//  ToDoApp2Tests.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 04.12.2023.
//

import XCTest
@testable import ToDoApp2

final class ToDoApp2Tests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testInitialViewControllerIsTaskListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers.first as! TaskListViewController
        
        XCTAssertTrue(rootViewController is TaskListViewController )
    }
    
    

}
