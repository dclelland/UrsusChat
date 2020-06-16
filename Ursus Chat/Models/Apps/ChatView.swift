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
    
    @discardableResult func primary(handler: @escaping (SubscribeEvent) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
    struct Primary: Decodable {
        
        struct ChatInitial: Decodable {
            
            struct Config: Decodable {
                
                var length: Int
                var read: Int
                
            }
            
            struct Envelope: Decodable {
                
                struct Letter: Decodable {

                    #warning("TODO: Letters should be enums: `text`, `url`, and `code` {expression: String, output: [[String]]}")
//                    var text: String
                    
                }

                #warning("TODO: Dates should decode from integers")
                var when: Date
                var author: String
                var number: Int
                var letter: Letter
                var uid: String
                
            }
            
            var config: Config
            var envelopes: [Envelope]
            
        }
        
        var chatInitial: [String: ChatInitial]
        
    }
    
}
