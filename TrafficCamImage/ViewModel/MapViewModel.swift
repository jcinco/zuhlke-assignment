//
//  MapViewModel.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/18/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation
import MapKit

class MapViewModel:NSObject {
    
    
    private var _repo: CamRepositoryProtocol? = nil
    var reposiory: CamRepositoryProtocol? {
        set(value) {
            _repo = value
        }
        get {
            return _repo
        }
    }
    
    // Singapore map coordinate (read only)
    var initialCoordinates: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D (
                latitude: CLLocationDegrees(exactly: 1.3521) ?? 0,
                longitude: CLLocationDegrees(exactly: 103.8198) ?? 0
            )
        }
    }
    
    
    
    func getCameraList(onResponse: @escaping ([CameraAnnotation]?, DataError?)->Void) {
        var failure = DataError()
        guard let inRepository = reposiory else {
            failure.message = "No repository is set"
            failure.statusCode = -1
            onResponse([], failure)
            return
        }
        
        inRepository.getAllCam { cams, error in
            if (error != nil) {
                onResponse([], error)
            }
            else {
                let camAnnotList = cams?.map { CameraAnnotation(camera: $0) }
                onResponse(camAnnotList, nil)
            }
        }
        
    }
    
    
    func getImageForCam(camera: Camera, callback: @escaping (UIImage?)->Void) {
        if (self.reposiory != nil) {
            self.reposiory?.getCamImage(camId: camera.cameraId ?? "") { data in
                DispatchQueue.main.async {
                    if (nil != data) {
                        callback(UIImage(data: data!))
                    }
                    else {
                        callback(nil)
                    }
                }
            }
        }
    }
    
    
    func destroy() {
        
        self.reposiory = nil
    }
    
    
    // singleton implementation
    private static var _instance: MapViewModel!
    public static var sharedInstance: MapViewModel! {
        get {
            if (nil == _instance) {
                _instance = MapViewModel()
            }
            return _instance
        }
    }
    private override init() {
        super.init()
    }
}
