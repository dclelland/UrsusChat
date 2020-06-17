//
//  PokeResponse.swift
//  Ursus
//
//  Created by Daniel Clelland on 7/06/20.
//

import Foundation

internal struct PokeResponse: Decodable {
    
    internal enum Result {
        
        case okay
        case error(String)
        
    }
    
    var id: Int
    var result: Result
    
    enum CodingKeys: String, CodingKey {
        case id
        case okay = "ok"
        case error = "err"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        switch Set(container.allKeys) {
        case [.id, .okay]:
            self.result = .okay
        case [.id, .error]:
            self.result = .error(try container.decode(String.self, forKey: .error))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}
