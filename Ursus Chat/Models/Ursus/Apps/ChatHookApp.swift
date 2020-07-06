//
//  ChatHookApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func chatHook(ship: Ship) -> ChatHookApp {
        return app(ship: ship, app: "chat-hook")
    }
    
}

class ChatHookApp: UrsusApp {
    
    @discardableResult func synced(handler: @escaping (SubscribeEvent<SyncedResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/synced", handler: handler)
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
    
}
