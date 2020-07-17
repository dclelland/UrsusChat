//
//  URLSessionConfiguration+Extensions.swift
//  Alamofire
//
//  Created by Daniel Clelland on 14/06/20.
//

import Foundation

extension URLSessionConfiguration {
    
    internal static func eventSource(lastEventID: String? = nil) -> URLSessionConfiguration {
        let sessionConfiguration = URLSessionConfiguration.default
        
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(Int32.max)
        sessionConfiguration.timeoutIntervalForResource = TimeInterval(Int32.max)
        sessionConfiguration.httpAdditionalHeaders = [
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache"
        ]
        
        if let lastEventID = lastEventID {
            sessionConfiguration.httpAdditionalHeaders?["Last-Event-Id"] = lastEventID
        }

        return sessionConfiguration
    }
    
}
