//
//  DataProviderTests.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 17.01.2024.
//

import XCTest
@testable import ToDoApp2

final class DataProviderTests: XCTestCase {
    
    var sut: DataProvider!
    var tableView: UITableView!
    var controller: TaskListViewController!

    override func setUpWithError() throws {
        super.setUp()
        sut = DataProvider()
        sut.taskManager = TaskManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as? TaskListViewController
        
        controller.loadViewIfNeeded()
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        sut.taskManager?.removeAll()
        try! super.tearDownWithError()
    }
    
    func testNumberOfSectionsIsTwo() {
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func testNumberOfRowsInSectionZeroIsTasksCount() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2 )
    }
    
    func testNumberOfRowsInSectionOneIsDoneTasksCount() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        sut.taskManager?.checkTask(at: 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2 )
    }
    
    func testCellForRowAtIndexPathReturnsTaskCell() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is TaskCell)
    }
    
    func testCellForRowAtIndexPathDequeuesCellFromTableView() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockTableView.cellIsDequeued)
    }
    
    func testCellForRowInSectionZeroCallsConfigure() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockTaskCell
        XCTAssertEqual(task, cell.task)
    }
    
    func testCellForRowInSectionOneCallsConfigure() {
        let task = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        
        sut.taskManager?.add(task: task)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(at: 0)
        
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockTaskCell
        XCTAssertEqual(task, cell.task)
    }
    
    func testDeleteButtonTitleSectionZeroShowsDone() {
        let titleButton = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(titleButton, "Done")
    }
    
    func testDeleteButtonTitleSectionOneShowsDone() {
        let titleButton = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        XCTAssertEqual(titleButton, "Undone")
    }
    
    func testCheckingTaskChecksInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }
    
    func testUncheckingTaskChecksInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
    
}

extension DataProviderTests {
    class MockTableView: UITableView {
        var cellIsDequeued = false
        
        static func mockTableView(withDataSource dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 50, width: 375, height: 658), style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            
            return mockTableView
        }
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellIsDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
    
    class MockTaskCell: TaskCell {
        var task: Task?
        
        override func configure(withTask task: Task, isDone: Bool = false) {
            self.task = task
        }
    }
}
