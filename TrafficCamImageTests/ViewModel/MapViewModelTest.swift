//
//  MapViewModel.swift
//  TrafficCamImageTests
//
//  Created by John Freidrich Cinco on 7/18/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation
import XCTest
@testable import TrafficCamImage

class MapViewModelTest: XCTestCase {
    private var mockRepo: CamRepositoryProtocol? = nil
    private var viewModel: MapViewModel!
    
    override func setUp() {
        self.viewModel = MapViewModel.sharedInstance
        self.viewModel.reposiory = MockRepository()
    }
    
    func testGetCamsSuccess() {
        // Arrange
        MockRepository.isSuccess = true
        var expectation = self.expectation(description: "Fetch camera annotation list success")
        var camList: [CameraAnnotation]? = nil
        var failure: DataError? = nil
        
        
        // Act
        self.viewModel.getCameraList { list, error in
            failure = error
            camList = list
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        // Assert
        XCTAssertTrue(camList?.count ?? 0 > 0)
        XCTAssertNil(failure)
    }
    
    func testGetCamsFailure() {
        // Arrange
        MockRepository.isSuccess = false
        var expectation = self.expectation(description: "Fetch camera annotation list failure")
        var camList: [CameraAnnotation]? = nil
        var failure: DataError? = nil
        
        
        // Act
        self.viewModel.getCameraList { list, error in
            failure = error
            camList = list
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        // Assert
        XCTAssertTrue(camList?.count ?? 1 < 1)
        XCTAssertNotNil(failure)
    }
    
    
    
}




class MockRepository: CamRepositoryProtocol {
    public static var isSuccess = true
    
    var provider: CamProviderProtocol?
    
    func getAllCam(callback: @escaping ([Camera]?, DataError?) -> Void) {
        if (MockRepository.isSuccess) {
            do {
                // return a list of camera object
                let cam = try Camera(json: mockCamsJson)
                callback([cam], nil)
            }
            catch let e as NSError {
                print(e.localizedDescription)
            }
        }
        else {
            // return failure
            callback([], DataError(message: "Failed", statusCode: -1))
        }
    }
    
    func getCamImage(camId: String, callback: @escaping (Data?, String?) -> Void) {
        if (MockRepository.isSuccess) {
            // return a dummy data
            let dummyData = Data("abc".utf8)
            callback(dummyData, "2020-07-18T16:00:00")
        }
        else {
            // return failure
            callback(nil, nil)
        }
    }
    
    // Mock camera json
    let mockCamsJson = """
    {
      "timestamp": "2020-07-17T16:59:53+08:00",
      "image": "https://images.data.gov.sg/api/traffic-images/2020/07/095cf511-5ba0-4fae-9355-2156753a6cfb.jpg",
      "location": {
        "latitude": 1.27414394350065,
        "longitude": 103.851316802547
      },"camera_id": "1501",
      "image_metadata": {
        "height": 240,
        "width": 320,
        "md5": "bb7044ac0898e2c4526ab47f46b605bc"
      }
    }
    """
}
