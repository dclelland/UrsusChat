//
//  PokeError.swift
//  Alamofire
//
//  Created by Daniel Clelland on 12/06/20.
//

import Foundation

public enum PokeError: Error {
    
    case channelRequestFailed(Error)
    case channelRequestFinished(HTTPURLResponse)
    case pokeError(String)
    
}
