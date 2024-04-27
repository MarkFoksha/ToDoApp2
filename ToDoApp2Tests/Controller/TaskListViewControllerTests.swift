//
//  TaskListViewControllerTests.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 17.01.2024.
//

import XCTest
@testable import ToDoApp2

final class TaskListViewControllerTests: XCTestCase {

    var sut: TaskListViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        
        sut = vc as? TaskListViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testwhenViewIsLoadedTableViewNotNill() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testWhenViewIsLoadedDataProviderNotNill() {
        XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableviewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func testWhenViewIsLoadedTableviewDataSourceIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    func testWhenViewIsLoadedTableviewDelegateEqualsDataSource() {
        XCTAssertEqual(sut.tableView.delegate as? DataProvider, 
                       sut.tableView.dataSource as? DataProvider)
    }
    
    func testTaskListVCHasBarButtonItemAsSelf() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    func presentingNewTaskViewController() -> NewTaskViewController {
        guard let newTaskButton = sut.navigationItem.rightBarButtonItem,
              let action = newTaskButton.action else { return NewTaskViewController() }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        return newTaskViewController
    }
    
    func testAddNewTaskPresentsNewTaskViewController() {
        let newTaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(newTaskViewController.titleTextField)
    }
    
    func testSharesSameTaskManagerWithNewTaskVC() {
        let newTaskViewController = presentingNewTaskViewController()
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
    }
    
    func testWhenViewAppearedTableViewReloaded() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager?.add(task: task)
        
        expectation(forNotification: NSNotification.Name(rawValue: "notification"), object: nil) { notification in
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else {
                return false
            }
            return task == taskFromNotification
        }
        let tableView = sut.tableView
        tableView?.delegate?.tableView?(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 1)
    }
    
    func testSelectedCellPushesNotificationToDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        sut.loadViewIfNeeded()
        
        let task = Task(title: "Foo")
        let task1 = Task(title: "Bar")
        
        sut.dataProvider.taskManager?.add(task: task)
        sut.dataProvider.taskManager?.add(task: task1)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notification"),
                                        object: self,
                                        userInfo: ["task" : task1])
        guard let detailedViewController = mockNavigationController.pushedViewController as? DetailViewController else {
            XCTFail()
            return
        }
        detailedViewController.loadViewIfNeeded()
        
        XCTAssertNotNil(detailedViewController.titleLabel)
        XCTAssertTrue(detailedViewController.task == task1)
    }
    
}

extension TaskListViewControllerTests {
    class MockTableView: UITableView {
        var isReloaded = false
        
        override func reloadData() {
            isReloaded = true
        }
    }
}

extension TaskListViewControllerTests {
    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
        
    }
}
