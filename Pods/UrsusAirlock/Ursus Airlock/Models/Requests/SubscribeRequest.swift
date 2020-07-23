//
//  Subscribe.swift
//  Ursus
//
//  Created by Daniel Clelland on 4/06/20.
//

import Foundation

internal struct SubscribeRequest: Encodable {
    
    var action: String = "subscribe"
    var id: Int
    var ship: Ship.Prefixless
    var app: String
    var path: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case id
        case ship
        case app
        case path
    }
    
}
