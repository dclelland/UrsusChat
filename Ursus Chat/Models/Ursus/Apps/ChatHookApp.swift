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
    
}

extension ChatHookApp {
    
    @discardableResult func sendMessage(path: String, letter: Letter, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let action = ChatHookApp.Action.message(
            Message(
                path: path,
                envelope: Message.Envelope(
                    uid: UUID().patUVString,
                    number: 0,
                    author: ship,
                    when: Int(Date().timeIntervalSince1970 * 1000.0), // Might be the date formatting (Int...?) // 1595467736125
                    letter: letter
                )
            )
        )
        return pokeRequest(json: action, handler: handler)
    }
    
    @discardableResult func sendRead(path: String, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let action = ChatHookApp.Action.read(
            Read(
                path: path
            )
        )
        return pokeRequest(json: action, handler: handler)
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
    
    enum Action: Encodable {
        
        case message(Message)
        case read(Read)
        
        enum CodingKeys: String, CodingKey {
            
            case message
            case read
            
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .message(let message):
                try container.encode(message, forKey: .message)
            case .read(let read):
                try container.encode(read, forKey: .read)
            }
        }
        
    }
    
    struct Message: Encodable {
        
        var path: String
        var envelope: Envelope
        
        struct Envelope: Codable {

            var uid: String
            var number: Int
            var author: Ship
            var when: Int
            var letter: Letter
            
        }
        
    }
    
    struct Read: Encodable {
        
        var path: String
        
    }
    
}
