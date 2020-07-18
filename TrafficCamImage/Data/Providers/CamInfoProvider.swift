//
//  CamInfoProvider.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation


class CamInfoProvider: CamProviderProtocol {
    private let kItems: String = "items"
    private let kCameras: String = "cameras"
    private let httpGetClass: HttpGet.Type?
    
    private var getClient:HttpGet? = nil
    var client: HttpGet? {
        get {
            return self.getClient
        }
    }
    
    
    private let endpoint: String = "https://api.data.gov.sg/v1/transport/traffic-images"
    
    public init(client: HttpGet.Type) {
        let url = URL(string: endpoint)
        self.getClient = client.init(url: url!)
        self.httpGetClass = client
    }
    
    
    /**
        Fetches the camera meta data from the server.
     
     - parameter String - the timestamp
     - parameter ([Camera]?, DataError?)->Void - Callback block
     */
    func fetchCameras(timeStamp: String?, onResponse: @escaping ([Camera]?, DataError?) -> Void) {
        var failure = DataError()
        
        // Validation
        guard let inTimeStamp = timeStamp else {
            failure.message = "timestamp is nil"
            failure.statusCode = -1
            onResponse(nil, failure)
            return
        }
       
        if (self.getClient == nil) {
            failure.message = "httpclient is nil"
            failure.statusCode = -1
            onResponse(nil, failure)
            return
        }
        
        if (inTimeStamp.isEmpty) {
            failure.message = "timestamp is empty"
            failure.statusCode = -1
            onResponse(nil, failure)
            return
        }
        
        
        
        self.getClient?.execute { (data, response, error) in
            
            guard let inData = data else {
                failure.message = response?.debugDescription
                failure.statusCode = response?.statusCode
                onResponse(nil, failure)
                return
            }
            
            do {
                let jsonString = try JSONSerialization.jsonObject(with: inData, options: .allowFragments)
                print(jsonString)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let result = try decoder.decode(CamResponse.self, from: inData)
                let cams = result.items?.first
                onResponse(cams?.cameras, nil)
            }
            catch let e as NSError {
                print(e.localizedDescription)
                failure.message = e.localizedFailureReason
                failure.statusCode = e.code
                onResponse(nil, failure)
            }
        }
        
    }
    
    
    
    func getImage(forCamId: String, onResponse: @escaping (Data?) -> Void) {
        // first get the latest info
        self.fetchCameras(timeStamp: self.getTimeStampNow()) { cams, failure in
            // if failure
            if (failure?.statusCode != nil) {
                onResponse(nil)
            }
            else {
                let cam = cams?.filter { $0.cameraId == forCamId }.first
                if (cam != nil) {
                    let imgUrl = URL(string: cam?.image ?? "")!
                    let request:HttpGet? = self.httpGetClass?.init(url: imgUrl)
                    request?.execute { data, httpResponse, error in
                        if (httpResponse?.statusCode == 200) {
                            onResponse(data)
                        }
                        else {
                            onResponse(nil)
                        }
                    }
                }
            }
        }
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
    
}
