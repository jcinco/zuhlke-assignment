//
//  CameraAnnotation.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation
import MapKit

open class CameraAnnotation: MKPointAnnotation {
    private var _camera: Camera? = nil
    var camera: Camera? {
        get {
            return _camera
        }
    }
    
    init(camera: Camera) {
        super.init()
        self._camera = camera
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude = self._camera?.location?.latitude ?? 0 as CLLocationDegrees
        coordinate.longitude = self._camera?.location?.longitude ?? 0 as CLLocationDegrees
        self.coordinate = coordinate
        
    }
}
