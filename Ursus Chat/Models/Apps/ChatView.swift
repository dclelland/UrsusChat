//
//  ChatViewApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 16/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func chatView(ship: String) -> ChatView {
        return app(ship: ship, app: "chat-view")
    }
    
}

class ChatView: UrsusApp {
    
    @discardableResult func primary(handler: @escaping (SubscribeEvent<Primary>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
}

extension ChatView {
    
    enum Primary: Decodable {
        
        case chatInitial(ChatStore.Inbox)
        case chatUpdate(ChatStore.Update)
        
        enum CodingKeys: String, CodingKey {
            
            case chatInitial
            case chatUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.chatInitial]:
                self = .chatInitial(try container.decode(ChatStore.Inbox.self, forKey: .chatInitial))
            case [.chatUpdate]:
                self = .chatUpdate(try container.decode(ChatStore.Update.self, forKey: .chatUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
