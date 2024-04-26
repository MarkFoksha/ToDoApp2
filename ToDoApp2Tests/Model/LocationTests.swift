//
//  LocationTests.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 15.01.2024.
//

import XCTest
import CoreLocation

@testable import ToDoApp2

final class LocationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitSetsName() {
        let location = Location(name: "Foo")
        XCTAssertEqual(location.name, "Foo")
    }

    func testInitSetsCoordinates() {
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(name: "Foo", coordinate: coordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }
    
    func testCanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0))
        
        let dict: [String: Any] = ["name" : "Foo",
                                   "latitude" : 10.0,
                                   "longitude" : 10.0]
        let createdLocation = Location(dict: dict)
        XCTAssertEqual(location, createdLocation)
    }
    
    func testCanBeSerialisedIntoDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0))
        
        let generatedLocation = Location(dict: location.dict)
        
        XCTAssertEqual(location, generatedLocation)
    }

}
