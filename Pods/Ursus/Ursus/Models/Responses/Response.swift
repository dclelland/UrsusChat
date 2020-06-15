//
//  Response.swift
//  Ursus
//
//  Created by Daniel Clelland on 7/06/20.
//

import Foundation

internal enum Response: Decodable {
    
    case poke(PokeResponse)
    case subscribe(SubscribeResponse)
    case diff(DiffResponse)
    case quit(QuitResponse)
    
    enum Response: String, Decodable {
        case poke
        case subscribe
        case diff
        case quit
    }
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Response.self, forKey: .response) {
        case .poke:
            self = .poke(try PokeResponse(from: decoder))
        case .subscribe:
            self = .subscribe(try SubscribeResponse(from: decoder))
        case .diff:
            self = .diff(try DiffResponse(from: decoder))
        case .quit:
            self = .quit(try QuitResponse(from: decoder))
        }
    }
    
}
