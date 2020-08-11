//
//  AirlockLoginResponseSerializerError.swift
//  Alamofire
//
//  Created by Daniel Clelland on 23/07/20.
//

import Foundation

internal enum AirlockLoginResponseSerializerError: LocalizedError {
    
    case missingAuthenticationHeader
    case invalidAuthenticationHeader(String)
    
    public var errorDescription: String? {
        switch self {
        case .missingAuthenticationHeader:
            return "Login response missing authentication header"
        case .invalidAuthenticationHeader:
            return "Login response returned invalid authentication header"
        }
    }
    
}
