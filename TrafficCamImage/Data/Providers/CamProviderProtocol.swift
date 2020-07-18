//
//  CamProviderProtocol.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/18/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation

struct CamProviderFailure {
    var statusCode: Int?
    var message: String?
}


protocol CamProviderProtocol {
    func fetchCameras(timeStamp: String?, onResponse: @escaping ([Camera]?, DataError?) -> Void)
    
    func getImage(forCamId: String, onResponse: @escaping (Data?)->Void)
}
