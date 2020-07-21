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
    
    @discardableResult func sendMessage(path: String, letter: Letter) -> DataRequest {
        #warning("WORK IN PROGRESS")
//        let envelope = Envelope(
//            uid: UUID().patUVString,
//            number: 0,
//            author: ship,
//            when: Date(),
//            letter: letter
//        )
        //        `chat-hook`: `{"message": {"path: "/~/~zod/mc", "envelope": {"uid": "0v3.l14pg.36jh8.mh9dl.ps65v.4lujh", "number": 1, "author: "~zod", "when": 15942876211449, "letter": {"text": "Hello world"}}}}`
        
        fatalError()
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
