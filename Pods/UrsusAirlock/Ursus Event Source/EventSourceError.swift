//
//  EventSourceError.swift
//  Alamofire
//
//  Created by Daniel Clelland on 15/06/20.
//

import Foundation

public enum EventSourceError: Error {
    
    case requestFailed(Error)
    case requestFinished(HTTPURLResponse)
    
}
