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
    
    enum Primary: Decodable {
        
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
        
        enum ChatUpdate: Decodable {
            
            struct Create: Decodable {
                
                var path: String
                
            }
            
            struct Delete: Decodable {
                
                var path: String
                
            }
            
            struct Message: Decodable {
                
                var path: String
                var envelope: Primary.ChatInitial.Envelope
                
            }
            
            struct Read: Decodable {
                
                var path: String
                
            }
            
            case create(Create)
            case delete(Delete)
            case message(Message)
            case read(Read)
            
            enum CodingKeys: String, CodingKey {
                
                case create
                case delete
                case message
                case read
                
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                switch Set(container.allKeys) {
                case [.create]:
                    self = .create(try container.decode(Create.self, forKey: .create))
                case [.delete]:
                    self = .delete(try container.decode(Delete.self, forKey: .delete))
                case [.message]:
                    self = .message(try container.decode(Message.self, forKey: .message))
                case [.read]:
                    self = .read(try container.decode(Read.self, forKey: .read))
                default:
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
                }
            }
            
        }
        
        case chatInitial([String: ChatInitial])
        case chatUpdate(ChatUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case chatInitial
            case chatUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.chatInitial]:
                self = .chatInitial(try container.decode([String: ChatInitial].self, forKey: .chatInitial))
            case [.chatUpdate]:
                self = .chatUpdate(try container.decode(ChatUpdate.self, forKey: .chatUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
