//
//  CamInfoProviderTest.swift
//  TrafficCamImageTests
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation
import XCTest

@testable import TrafficCamImage

class CamInfoProviderTest: XCTestCase {
    private var provider: CamInfoProvider?
    
    override func setUp() {
        // Mock
        self.provider = CamInfoProvider(client: MockJsonGetClient.self)
        
    }
    
    override func tearDown() {
        self.provider = nil
    }
    
    
    func testSuccessFetchCameras() {
        // Happy path
        // Arrange
         MockJsonGetClient.isSuccess = true
        
        let expectation = self.expectation(description: "successful fetch")
        var result: [Camera]? = nil
        let timeStamp = "2020-07-17T13:00:00"
        // Act
        self.provider?.fetchCameras(timeStamp: timeStamp) { (cams: [Camera]?, failure: DataError?) in
            result = cams
            expectation.fulfill()
        }
        
        // Assert
       waitForExpectations(timeout: 30, handler: nil)
       XCTAssertNotNil(result)
    }
    
    
    func testNullData() {
        // Arrange
       
        MockJsonGetClient.isSuccess = true
        MockJsonGetClient.returnNull = true
        
        let expectation = self.expectation(description: "nulldata")
        var result: [Camera]? = nil
        var fail: DataError? = nil
        let timeStamp = "2020-07-17T13:00:00"
        // Act
        self.provider?.fetchCameras(timeStamp: timeStamp) { cams, failure in
            result = cams
            fail = failure
            expectation.fulfill()
        }
        // Assert
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNil(result) // result should be nil
        XCTAssertNotNil(fail)
        XCTAssertNotNil(fail?.statusCode)
        XCTAssertNotNil(fail?.message)
        
    }
    
    
    func testFailedFetchCameras() {
        // Arrange
         MockJsonGetClient.isSuccess = false
         let expectation = self.expectation(description: "failed fetch")
         var result: [Camera]? = nil
         let timeStamp = "2020-07-17T13:00:00"
         // Act
         self.provider?.fetchCameras(timeStamp: timeStamp) { cams, failure in
             result = cams
             expectation.fulfill()
         }
         // Assert
         waitForExpectations(timeout: 30, handler: nil)
         XCTAssertNil(result) // result should be nil
    }
    
    
    func testInvalidTimestamp() {
        // Arrange
        MockJsonGetClient.isSuccess = false
         let expectation = self.expectation(description: "failed fetch")
        var timeStamp: String? = nil
        var result: [Camera]? = nil
        var failure: DataError? = nil
         // Act
         self.provider?.fetchCameras(timeStamp: timeStamp) { cams, fail in
             result = cams
             failure = fail
             expectation.fulfill()
         }
         // Assert
         waitForExpectations(timeout: 30, handler: nil)
         XCTAssertNil(result) // result should be nil
         XCTAssertNotNil(failure) // should have a failure object returned
    }
    
    
    
    func testGetImageDataTest() {
        
        // Arrange
        MockJsonGetClient.isSuccess = true
               
        let expectation = self.expectation(description: "successful fetch image")
        let camId = "1501"
        var imageData: Data? = nil
        
        // Act
        self.provider?.getImage(forCamId: camId) { data in
            imageData = data
            expectation.fulfill()
        }
               
        // Assert
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(imageData)
    }
    
    func testGetImageDataFailure() {
        
        // Arrange
        MockJsonGetClient.isSuccess = false
        MockJsonGetClient.returnNull = true
               
        let expectation = self.expectation(description: "successful fetch image")
        let camId = "1501"
        var imageData: Data? = nil
        
        // Act
        self.provider?.getImage(forCamId: camId) { data in
            imageData = data
            expectation.fulfill()
        }
               
        // Assert
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNil(imageData)
    }
    
}







/**
 Mock client class
 */
class MockJsonGetClient: HttpGet {
    static var isSuccess: Bool = false
    static var returnNull: Bool = false
    static var mockMode: Bool = true

    private func loadMockJSON(callback: @escaping (Data?)->Void) {
        do {
            if (!MockJsonGetClient.returnNull) {
                let file = Bundle(for: CamInfoProviderTest.self).path(forResource: "camera", ofType:"json")
                let data = try Data(contentsOf: URL(fileURLWithPath: file ?? ""))
                callback(data)
            }
            else {
                callback(nil)
            }
        }
        catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
   
    
    override func execute(withCompletion:@escaping (Data?, HTTPURLResponse?, Error?)->Void) {
        
        if (!MockJsonGetClient.mockMode) {
            super.execute(withCompletion: withCompletion)
            return
        }
        
        // success scenario
        if (MockJsonGetClient.isSuccess) {
            // pass in a mock result data
            self.loadMockJSON() { result in
                withCompletion(result, HTTPURLResponse(), nil)
            }
        }
        // fail scenario
        else {
            let httpResponse = HTTPURLResponse()
            let error = NSError(domain: "Failed to fetch", code: 400, userInfo: nil) as Error
            
            // pass an error
            withCompletion(nil, httpResponse, error)
        }
        
    }
    
}


