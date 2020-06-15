//
//  EventSourceMessageField.swift
//  Alamofire
//
//  Created by Daniel Clelland on 15/06/20.
//

import Foundation

internal struct EventSourceMessageField {
    
    internal enum Key: String {
        
        case event
        case id
        case data
        case retry
        
    }
    
    internal var key: Key
    internal var value: String
    
    internal init?(parsing string: String) {
        let scanner = Scanner(string: string)
        
        guard let key = scanner.scanUpToString(":").flatMap(Key.init(rawValue:)) else {
            return nil
        }
        
        _ = scanner.scanString(":")
        
        guard let value = scanner.scanUpToString("\n") else {
            return nil
        }
        
        self.key = key
        self.value = value
    }
    
}
