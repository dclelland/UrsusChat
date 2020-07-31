//
//  ChatViewApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 16/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Airlock {
    
    func chatView(ship: Ship) -> ChatViewApp {
        return app(ship: ship, app: "chat-view")
    }
    
}

class ChatViewApp: AirlockApp {
    
    @discardableResult func primarySubscribeRequest(handler: @escaping (SubscribeEvent<SubscribeResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
    @discardableResult func messagesRequest(path: Path, start: Int, end: Int, handler: @escaping (AFResult<ChatViewApp.SubscribeResponse>) -> Void) -> DataRequest {
        let url = airlock.credentials.url.appendingPathComponent("/chat-view/paginate/\(start)/\(end)\(path)")
        return airlock.session
            .request(url)
            .validate()
            .responseDecodable(of: ChatViewApp.SubscribeResponse.self, decoder: airlock.decoder) { response in
                handler(response.result)
            }
    }
    
}

extension ChatViewApp {
    
    enum SubscribeResponse: Decodable {
        
        case chatUpdate(ChatUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case chatUpdate = "chat-update"
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.chatUpdate]:
                self = .chatUpdate(try container.decode(ChatUpdate.self, forKey: .chatUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
