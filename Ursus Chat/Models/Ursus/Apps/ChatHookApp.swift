//
//  ChatHookApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Airlock {
    
    func chatHook(ship: Ship) -> ChatHookApp {
        return app(ship: ship, app: "chat-hook")
    }
    
}

class ChatHookApp: AirlockApp {
    
    @discardableResult func synced(handler: @escaping (SubscribeEvent<SyncedResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/synced", handler: handler)
    }
    
    @discardableResult func sendMessage(path: String, letter: Letter, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let envelope = Envelope(
            uid: UUID().patUVString,
            number: 0,
            author: ship, // Might be the @p encoding
            when: Date(), // Might be the date formatting (Int...?)
            letter: letter
        )
        
        let message = Message(
            path: path,
            envelope: envelope
        )
        
        return pokeRequest(json: message, handler: handler)
    }
    
}

extension ChatHookApp {
    
    enum SyncedResponse: Decodable {
        
        case chatHookUpdate(ChatHookUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case chatHookUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.chatHookUpdate]:
                self = .chatHookUpdate(try container.decode(ChatHookUpdate.self, forKey: .chatHookUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
    struct Message: Encodable {
        
        var path: String
        var envelope: Envelope
        
    }
    
}
