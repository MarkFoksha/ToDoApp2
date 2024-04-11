//
//  APIClientTests.swift
//  ToDoApp2Tests
//
//  Created by Марк Фокша on 09.04.2024.
//

import XCTest
@testable import ToDoApp2

final class APIClientTests: XCTestCase {

    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUpWithError() throws {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut = APIClient()
        sut.urlSession = mockURLSession
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func userLogin() {
        let completionHandler = {(token: String?, error: Error?) in }
        sut.login(withName: "name", password: "%password", completionHandler: completionHandler)
    }

    func testLoginUsesCorrectHost() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoApp.com")
    }
    
    func testLoginUsesCorrectPath() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    func testLoginUsesExpectedQuery() {
        userLogin()
        
        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%password")
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
    
    // token -> Data -> completionHandler -> DataTask -> URLSession
    func testSuccessfulLoginCreatesToken() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let tokenExpectation = expectation(description: "Token expectation")
        var caughtToken: String?
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        sut.login(withName: "name", password: "password") { token, _ in
            caughtToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughtToken, "tokenString")
        }
    }
    
    func testLoginInvalidJSONReturnsError() {
        let errorExpectation = expectation(description: "Error expectation")
        var caughtError: Error?
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        sut.login(withName: "name", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    func testLoginWhenDataIsNilReturnsError() {
        let errorExpectation = expectation(description: "Error expectation")
        var caughtError: Error?
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        sut.login(withName: "name", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    func testLoginWhenRosponseErrorReturnsError() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let error = NSError(domain: "Server Error", code: 404)
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: error)
        sut.urlSession = mockURLSession
        sut.login(withName: "name", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
}

extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        private let mockDataTask: MockURLSessionDataTask
        var url: URL?
        
        var urlComponents: URLComponents? {
            guard let url = url else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, ( Error)?) -> Void) -> URLSessionDataTask {
            self.url = url
             
//            return URLSession.shared.dataTask(with: url)
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        typealias CompletionHandler = (Data?, URLResponse?, (Error)?) -> Void
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(
                    self.data,
                    self.urlResponse,
                    self.responseError
                )
            }
        }
    }
}
