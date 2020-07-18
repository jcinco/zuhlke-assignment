//
//  HttpJsonGet.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/17/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation

protocol HttpJsonGetProtocol {
    func execute(onJsonRequestResult:@escaping (Dictionary<String,Any?>?, HTTPURLResponse?, Error?)->Void)
}


open class HttpJsonGet: HttpGet, HttpJsonGetProtocol {
    
    internal var onJsonCompleteBlock:(Dictionary<String,Any?>?, HTTPURLResponse?, Error?)->Void = {(json:Dictionary<String,Any?>?, response:HTTPURLResponse?, error:Error?)->Void in}
    
    public required init(url: URL) {
        super.init(url: url)
        addHeader(value: "application/json", forHTTPHeaderField: "Accept")
        addHeader(value: "application/json", forHTTPHeaderField: "Content-Type")
    }
   
    
    public func execute(onJsonRequestResult:@escaping (Dictionary<String,Any?>?, HTTPURLResponse?, Error?)->Void) {
        //self.onJsonCompleteBlock = onJsonRequestResult
        super.execute { (data, response, error) in
            var resultData:[String:Any?]?
            if (nil == error) {
                
                do {
                    if (nil != data) {
                        let dataStr = String(data: data!, encoding: .utf8)!
                        resultData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any?>
                       
                    }
                }
                catch let err as NSError {
                    //self.onJsonCompleteBlock(["data":data], response, error)
                    onJsonRequestResult(["data":data], response, error)
                }
            }
            //self.onJsonCompleteBlock(resultData, response, error)
            onJsonRequestResult(resultData, response, error)
        }
    }
}

