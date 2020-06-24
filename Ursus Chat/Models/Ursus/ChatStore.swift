//
//  ChatStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 17/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Ursus

class ChatStore: UrsusApp {
    
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
    
    struct Envelope: Decodable {

        var uid: String
        var number: Int
        var author: String
        var when: Date
        var letter: Letter
        
    }
    
    struct Config: Decodable {
        
        var length: Int
        var read: Int
        
    }
    
    struct Mailbox: Decodable {
        
        var config: Config
        var envelopes: [Envelope]
        
    }
    
    typealias Inbox = [String: Mailbox]

}

extension ChatStore {
    
    enum Update: Decodable {
        
        struct Create: Decodable {
            
            var path: String
            
        }
        
        struct Delete: Decodable {
            
            var path: String
            
        }
        
        struct Message: Decodable {
            
            var path: String
            var envelope: Envelope
            
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
    
}
