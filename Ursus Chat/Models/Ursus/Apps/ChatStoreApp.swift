//
//  ChatStoreApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 23/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Airlock {
    
    func chatStore(ship: Ship) -> ChatStoreApp {
        return app(ship: ship, app: "chat-store")
    }
    
}

class ChatStoreApp: AirlockApp {
    
    @discardableResult func readPokeRequest(path: String, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let action = ChatStoreApp.Action.read(
            Read(
                path: path
            )
        )
        return pokeRequest(json: action, handler: handler)
    }
    
}

extension ChatStoreApp {
    
    enum Action: Encodable {
        
        case read(Read)
        
        enum CodingKeys: String, CodingKey {
            
            case read
            
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .read(let read):
                try container.encode(read, forKey: .read)
            }
        }
        
    }
    
    struct Read: Encodable {
        
        var path: String
        
    }
    
}

