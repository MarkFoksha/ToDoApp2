//
//  NewTaskViewControllerTests.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 08.04.2024.
//

import XCTest
import CoreLocation


@testable import ToDoApp2

final class NewTaskViewControllerTests: XCTestCase {

    var sut: NewTaskViewController!
    var placemark: MockPlacemark!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHasTitleTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    func testHasLocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func testHasDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func testHasAddressTextField() {
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
    }
    
    func testHasSaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func testHasCancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    
//    func testSaveButtonUsesGeocoderToConvertCoordinateFromAddress() {
//        let df = DateFormatter()
//        df.dateFormat = "dd.MM.yy"
//        let date = df.date(from: "01.01.24")
//        
//        sut.titleTextField.text = "Foo"
//        sut.locationTextField.text = "Bar"
//        sut.dateTextField.text = "01.01.24"
//        sut.addressTextField.text = "Черновцы"
//        sut.descriptionTextField.text = "Baz"
//        
//        sut.taskManager = TaskManager()
//        let mockGeocoder = MockCLGeocoder()
//        sut.geocoder = mockGeocoder
//        sut.save()
//        
//        let coordinate = CLLocationCoordinate2D(latitude: 48.2929906, longitude: 25.9329692)
//        let location = Location(name: "Bar", coordinate: coordinate)
//        
//        let placemark = MockPlacemark(coder: NSCoder())!
//
//        placemark.mockCoordinate = coordinate
//        mockGeocoder.completionHandler?([placemark], nil)
//        
//        let task = sut.taskManager.task(at: 0)
//        let generatedTask = Task(title: "Foo", description: "Baz", date: date, location: location)
//          
//        XCTAssertEqual(task, generatedTask)
//    }
    
    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        XCTAssertTrue(actions.contains("save"))
    }
    
    func testGeocoderFetchesCorrectCoordinates() {
        let addressString = "Черновцы"
        let geocoder = CLGeocoder()
        let geocoderAnswer = expectation(description: "Answer")
        
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            let placemark = placemarks?.first
            let location = placemark?.location
            
            guard let latitude = location?.coordinate.latitude,
                  let longitude = location?.coordinate.longitude 
            else
            {
                XCTFail()
                return
            }
            
            XCTAssertEqual(latitude,  48.2929906)
            XCTAssertEqual(longitude, 25.9329692)
            geocoderAnswer.fulfill()
        }
        waitForExpectations(timeout: 3)
    }
    
    func testTaskDismissesNewTaskViewController() {
        // given
        let mockNewTaskViewController = MockNewTaskViewController()
        
        mockNewTaskViewController.titleTextField = UITextField()
        mockNewTaskViewController.descriptionTextField = UITextField()
        mockNewTaskViewController.locationTextField = UITextField()
        mockNewTaskViewController.dateTextField = UITextField()
        mockNewTaskViewController.addressTextField = UITextField()
        
        mockNewTaskViewController.titleTextField.text = "Foo"
        mockNewTaskViewController.descriptionTextField.text = "Bar"
        mockNewTaskViewController.locationTextField.text = "Baz"
        mockNewTaskViewController.dateTextField.text = "01.01.24"
        mockNewTaskViewController.addressTextField.text = "Chernivtsi"
        
        mockNewTaskViewController.save()
        XCTAssertTrue(mockNewTaskViewController.isDismissed)
    }
}

extension NewTaskViewControllerTests {
    class MockCLGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            return CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}

extension NewTaskViewControllerTests {
    class MockNewTaskViewController: NewTaskViewController {
        var isDismissed = false
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDismissed = true
        }
    }
}
