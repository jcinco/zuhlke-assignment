//
//  CamRepository.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/18/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation

class CamRepository:NSObject, CamRepositoryProtocol {
    private var _provider: CamProviderProtocol? = nil
    var provider: CamProviderProtocol? {
        set(value) {
            _provider = value
        }
        get {
           return _provider
        }
    }
    
    
    /**
        Async: Retrieves the image associated with the cam
     
        - parameter String - The camera id
        - parameter (Data?)->Void - Callback
     */
    func getCamImage(camId: String, callback: @escaping (Data?) -> Void) {
        var failure = DataError()
        if provider == nil {
            failure.message = "No provider specified"
            failure.statusCode = -1
            return
        }
        
        self.provider?.getImage(forCamId: camId, onResponse: callback)
        
    }
   
    /**
        Async: Fetches all the camera info from the server
     
     - parameter callback: ([Camera]?, DataError?)->Void
     */
    func getAllCam(callback: @escaping ([Camera]?, DataError?)->Void) {
        var failure = DataError()
        guard let inProvider = provider else {
            failure.message = "No provider specified"
            failure.statusCode = -1
            return
        }
        
        // Call the
        inProvider.fetchCameras(timeStamp: getTimeStampNow()) { cams, failure in
            callback(cams, failure)
        }
        
    }
    
    func destroy() {
        self._provider = nil
    }
    
    /**
        Returns the latest timestamp
     */
    private func getTimeStampNow()->String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-ddTHH:mm:ss"
        return formatter.string(from: date)
    }
    
    
    
    /// Singleton implementation
    private static var _instance: CamRepository!
    public static var sharedInstance: CamRepository! {
        get {
            if (_instance == nil) {
                _instance = CamRepository()
            }
            
            return _instance
        }
    }
    private override init() {
        super.init()
    }
   
    public static func destroy() {
        _instance = nil
    }
    
}
