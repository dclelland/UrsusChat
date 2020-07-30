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
    
    @discardableResult func syncedSubscribeRequest(handler: @escaping (SubscribeEvent<Synced>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/synced", handler: handler)
    }
    
    @discardableResult func messagePokeRequest(path: String, letter: Letter, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let action = ChatHookApp.Action.message(
            Message(
                path: path,
                envelope: Envelope(
                    uid: UUID().patUVString,
                    number: 0,
                    author: ship,
                    when: Date(),
                    letter: letter
                )
            )
        )
        return pokeRequest(json: action, handler: handler)
    }
    
}

extension ChatHookApp {
    
    enum Synced: Decodable {
        
        case chatHookUpdate(ChatHookUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case chatHookUpdate = "chat-hook-update"
            
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
    
    enum Action: Encodable {
        
        case message(Message)
        
        enum CodingKeys: String, CodingKey {
            
            case message
            
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .message(let message):
                try container.encode(message, forKey: .message)
            }
        }
        
    }
    
    struct Message: Encodable {
        
        var path: String
        var envelope: Envelope
        
    }
    
}
