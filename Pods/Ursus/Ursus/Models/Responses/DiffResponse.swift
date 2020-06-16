//
//  DiffResponse.swift
//  Ursus
//
//  Created by Daniel Clelland on 7/06/20.
//

import Foundation

internal struct DiffResponse: Decodable {
    
    var id: Int
    var json: Data
    
    enum CodingKeys: String, CodingKey {
        case id
        case json
    }
    
}
