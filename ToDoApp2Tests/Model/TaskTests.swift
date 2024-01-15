//
//  TaskTests.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 03.01.2024.
//

import XCTest
@testable import ToDoApp2

final class TaskTests: XCTestCase {
    func testInitTaskWithTitle() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task)
    }
     
    func testInitTaskWithTitleAndDescription() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertNotNil(task)
    }
    
    func testWhenGivenTitleSetsTitle() {
        let task = Task(title: "Foo")
        
        XCTAssertEqual(task.title, "Foo")
    }
    
    func testWhenGivenDescritionSetsDescription() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertTrue(task.description == "Bar")
    }
    
    func testTaskInitsWithDate() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task .date)
    }
    
    func testWhenGivenLocationSetsLocation() {
        let location = Location(name: "Foo")
        let task = Task(title: "Bar", description: "Foo", location: location)
        
        XCTAssertEqual(location, task.location)
    }
}
