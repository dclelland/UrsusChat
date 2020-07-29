//
//  AirlockLoginResponseSerializerError.swift
//  Alamofire
//
//  Created by Daniel Clelland on 23/07/20.
//

import Foundation

internal enum AirlockLoginResponseSerializerError: Error {
    
    case missingAuthenticationHeader
    case invalidAuthenticationHeader(String)
    
}
