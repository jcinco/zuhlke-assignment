//
//  CamRepository.swift
//  TrafficCamImageTests
//
//  Created by John Freidrich Cinco on 7/18/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation
import XCTest
@testable import TrafficCamImage

class CamRespositoryTest: XCTestCase {
    private var mockProvder: MockCamProvider? = nil
    private var repository: CamRepository? = nil
    override func setUp() {
        self.mockProvder = MockCamProvider()
        self.repository = CamRepository.sharedInstance
        self.repository?.provider = mockProvder
    }
    
    
    func testGetAllCamsSuccess() {
        // Arrange
        let expectation = self.expectation(description: "get all cams successfuly")
        self.mockProvder?.isSuccess = true
        
        var camList: [Camera]? = nil
        var fail: DataError? = nil
        
        // Act
        self.repository?.getAllCam { cams, failure in
            camList = cams
            fail = failure
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        
        // Assert
        XCTAssertNotNil(camList)
        XCTAssertTrue(camList?.count ?? 0 > 0) // should be greater than zero
        XCTAssertNil(fail)
       
    }
    
    
    func testGetAllCamsFail() {
        // Arrange
        let expectation = self.expectation(description: "get all cams successfuly")
        self.mockProvder?.isSuccess = false
        
        var camList: [Camera]? = nil
        var fail: DataError? = nil
        
        // Act
        self.repository?.getAllCam { cams, failure in
            camList = cams
            fail = failure
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        
        // Assert
        XCTAssertNil(camList)
        XCTAssertTrue(camList?.count ?? 0 == 0) // should be greater than zero
        XCTAssertNotNil(fail)
    }
    
    
    func testGetCamImageSuccess() {
        // Arrange
        let expectation = self.expectation(description: "get cam image successfuly")
        self.mockProvder?.isSuccess = true
        
        var imageData: Data? = nil
        var timestamp: String? = nil
        // Act
        self.repository?.getCamImage(camId: "1501") { data, time in
            imageData = data
            timestamp = time
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        
        // Assert
        XCTAssertNotNil(imageData)
        XCTAssertNotNil(timestamp)
       
    }
    
}







// Mock provider class
class MockCamProvider: CamProviderProtocol {
    var isSuccess:Bool = true
    
    func fetchCameras(timeStamp: String?, onResponse: @escaping ([Camera]?, DataError?) -> Void) {
        var cams: [Camera]? = nil
        if (self.isSuccess) {
            // return a list of camera objects
            let cam = Camera(timestamp: "2020-07-18T11:00:00", cameraId: "1501", image: "", image_metadata: nil, location: nil)
            cams = [cam]; // we just need one for now
            onResponse(cams, nil)
        }
        else {
            // return a failure
            onResponse(cams, DataError(message: "failed to retrieve", statusCode: -1))
        }
    }
    
    func getImage(forCamId: String, onResponse: @escaping (Data?, String?) -> Void) {
        if (self.isSuccess) {
            let mockData = Data("abc".utf8)
            onResponse(mockData, "2020-07-18T16:00:00")
        }
        else {
             // return a failure
            onResponse(nil, nil)
        }
    }
    
}
