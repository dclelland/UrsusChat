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
                
                enum Letter: Decodable {
                    
                    struct Code: Decodable {
                        
                        var expression: String
                        var output: [[String]]
                        
                    }
                    
                    case text(String)
                    case url(URL)
                    case code(Code)
                    case me(String)
                    
                    enum CodingKeys: String, CodingKey {
                        
                        case text
                        case url
                        case code
                        case me
                        
                    }
                    
                    init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self)
                        switch Set(container.allKeys) {
                        case [.text]:
                            self = .text(try container.decode(String.self, forKey: .text))
                        case [.url]:
                            self = .url(try container.decode(URL.self, forKey: .url))
                        case [.code]:
                            self = .code(try container.decode(Code.self, forKey: .code))
                        case [.me]:
                            self = .me(try container.decode(String.self, forKey: .code))
                        default:
                            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
                        }
                    }
                    
                }

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
