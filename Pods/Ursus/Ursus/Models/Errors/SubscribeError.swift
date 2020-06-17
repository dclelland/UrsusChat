//
//  SubscribeError.swift
//  Alamofire
//
//  Created by Daniel Clelland on 12/06/20.
//

import Foundation

public enum SubscribeError: Error {
    
    case channelRequestFailed(Error)
    case channelRequestFinished(HTTPURLResponse)
    case subscribeError(String)
    
}
