//
//  UrsusDecoder.swift
//  Alamofire
//
//  Created by Daniel Clelland on 13/06/20.
//

import Foundation

extension JSONDecoder {
    
    internal func decodeJSON<T>(_ type: T.Type, from data: Data, options: JSONSerialization.ReadingOptions = []) throws -> T where T : Decodable {
        userInfo[.json] = try JSONSerialization.jsonObject(with: data, options: options)
        let result = try decode(type, from: data)
        userInfo[.json] = nil
        return result
    }
    
}

extension CodingUserInfoKey {
    
    internal static let json = CodingUserInfoKey(rawValue: "json")!
    
}
