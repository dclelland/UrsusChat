//
//  Bundle+Extensions.swift
//  Alamofire
//
//  Created by Daniel Clelland on 15/07/20.
//

import Foundation

extension Bundle {
    
    internal static let ursusSigil = Bundle(identifier: "org.cocoapods.UrsusSigil")!
    
}

extension Bundle {
    
    internal func urlForSymbols() -> URL {
        return url(forResource: "index", withExtension: "json")!
    }
    
}
