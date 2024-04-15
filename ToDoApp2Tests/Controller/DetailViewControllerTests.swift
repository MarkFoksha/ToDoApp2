//
//  DetailViewController.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 19.03.2024.
//

import XCTest
import CoreLocation
@testable import ToDoApp2

final class DetailViewControllerTests: XCTestCase {

    private  var sut: DetailViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel.text)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel.text)
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    func testHasDateLabel() {
        XCTAssertNotNil(sut.dateLabel.text)
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    func testHasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel.text)
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }
    
    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }
     
    func setUpTaskAndAppearanceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 48.2864702, longitude: 25.9376532)
        let location = Location(name: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1704060000)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        sut.task = task
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    func testSettingTaskSetsTitleLabel() {
        setUpTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "Foo")
    }
    
    func testSettingTaskSetsDescriptionLabel() {
        setUpTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.descriptionLabel.text, "Bar")
    }
    
    func testSettingTaskSetsLocationLabel() {
        setUpTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.locationLabel.text, "Baz")
    }
    
    func testSettingTaskSetsDateLabel() {
        setUpTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.dateLabel.text, "01.01.24")
    }
    
    func testSettingTaskSetsMapView() {
        setUpTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 48.2864702, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, 25.9376532, accuracy: 0.001 )
    }
}
