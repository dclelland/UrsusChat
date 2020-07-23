//
//  Poke.swift
//  Ursus
//
//  Created by Daniel Clelland on 3/06/20.
//

import Foundation

internal struct PokeRequest<JSON: Encodable>: Encodable {
    
    var action: String = "poke"
    var id: Int
    var ship: Ship.Prefixless
    var app: String
    var mark: String
    var json: JSON
    
    enum CodingKeys: String, CodingKey {
        case action
        case id
        case ship
        case app
        case mark
        case json
    }
    
}
