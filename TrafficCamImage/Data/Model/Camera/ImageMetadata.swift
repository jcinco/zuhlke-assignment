//
//  ImageMetadata.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation

struct ImageMetadata: Codable {
    public var height: Int
    public var width: Int
    public var md5: String
}
