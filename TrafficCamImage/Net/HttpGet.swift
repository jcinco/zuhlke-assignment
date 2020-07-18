//
//  HttpGet.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation

open class HttpGet: HttpRequest {
    private let METHOD:String = "GET"
        
    public required init(url:URL)
    {
        super.init(withHTTPMethod:METHOD, forUrl:url)
    }
        
}

