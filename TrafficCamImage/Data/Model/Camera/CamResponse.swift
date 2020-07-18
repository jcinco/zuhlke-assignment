//
//  CamResponse.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation

/**
 {
   "api_info": {
     "status": "healthy"
   },
   "items": [
     {
       "timestamp": "2020-07-17T11:21:17.181Z",
       "cameras": [
         {
           "timestamp": "2020-07-17T11:21:17.181Z",
           "camera_id": 0,
           "image_id": 0,
           "image": "string",
           "image_metadata": {
             "height": 0,
             "width": 0,
             "md5": "string"
           }
         }
       ]
     }
   ]
 }
 */


struct CamResponse: Codable {
    var api_info: [String:String]?
    var items: [Cameras]?
}

struct Camera: Codable {
    var timestamp: String?
    var cameraId: String?
    var image: String?
    var image_metadata: ImageMetadata?
    var location: Location?
    
    private enum CodingKeys: String, CodingKey {
        case cameraId = "cameraId"
        case image_metadata = "imageMetadata"
        case image = "image"
        case location = "location"
        case timestamp = "timestamp"
    }
    
    init(json: String) throws {
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let cam = try decoder.decode(Camera.self, from: data)
        
        self.timestamp = cam.timestamp
        self.cameraId = cam.cameraId
        self.location = cam.location
        self.image = cam.image
        self.image_metadata = cam.image_metadata
    }
    
    init(timestamp: String?,
         cameraId: String?,
         image: String?,
         image_metadata: ImageMetadata?,
         location: Location?) {
        
        self.timestamp = timestamp
        self.cameraId = cameraId
        self.image = image
        self.image_metadata = image_metadata
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        timestamp = try container.decode(String.self, forKey: .timestamp)
        cameraId = try container.decode(String.self, forKey: .cameraId)
        image = try container.decode(String.self, forKey: .image)
        image_metadata = try container.decode(ImageMetadata.self, forKey: .image_metadata)
        location = try container.decode(Location.self, forKey: .location)
        
    }
}

struct Cameras: Codable {
    var timestamp: String?
    var cameras: [Camera]?
}

struct ImageMetadata: Codable {
    var height: Float?
    var width: Float?
    var md5: String?
}

struct Location: Codable {
    var latitude: Double = 0
    var longitude: Double = 0
}
