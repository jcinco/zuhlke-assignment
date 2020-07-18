//
//  Camera.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation

struct Camera: Codable {
    var timestamp: String
    var image: String
    var camera_id: Int
    var location: Location
    var image_metadata: ImageMetadata
}

struct Cameras: Codable {
    var timestamp: String
    var cameras: [Camera]
}
