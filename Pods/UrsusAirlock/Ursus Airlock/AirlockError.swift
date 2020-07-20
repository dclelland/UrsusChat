//
//  AirlockError.swift
//  Alamofire
//
//  Created by Daniel Clelland on 20/07/20.
//

import Foundation

public enum AirlockError: Error {
    
    case subscribeFailure(String)
    case pokeFailure(String)
    
}
