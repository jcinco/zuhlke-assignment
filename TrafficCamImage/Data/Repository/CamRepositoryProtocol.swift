//
//  CamRepositoryProtocol.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/18/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation

protocol CamRepositoryProtocol {
    
    var provider: CamProviderProtocol? {get set}
    
    func getAllCam(callback: @escaping ([Camera]?, DataError?)->Void)
    func getCamImage(camId: String, callback: @escaping (Data?)->Void)
}
