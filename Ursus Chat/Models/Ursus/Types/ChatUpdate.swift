//
//  ChatUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

enum ChatUpdate: Decodable {
    
    case initial(ChatUpdateInitial)
    case create(ChatUpdateCreate)
    case delete(ChatUpdateDelete)
    case message(ChatUpdateMessage)
    case messages(ChatUpdateMessages)
    case read(ChatUpdateRead)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case create
        case delete
        case message
        case messages
        case read
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(ChatUpdateInitial.self, forKey: .initial))
        case [.create]:
            self = .create(try container.decode(ChatUpdateCreate.self, forKey: .create))
        case [.delete]:
            self = .delete(try container.decode(ChatUpdateDelete.self, forKey: .delete))
        case [.message]:
            self = .message(try container.decode(ChatUpdateMessage.self, forKey: .message))
        case [.messages]:
            self = .messages(try container.decode(ChatUpdateMessages.self, forKey: .messages))
        case [.read]:
            self = .read(try container.decode(ChatUpdateRead.self, forKey: .read))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

enum ChatAction: String, Decodable {
    
    case create
    case delete
    case message
    case read
    
}

typealias ChatUpdateInitial = Inbox

typealias ChatUpdateCreate = String

typealias ChatUpdateDelete = String

struct ChatUpdateMessage: Decodable {
    
    var path: String
    var envelope: Envelope
    
}

struct ChatUpdateMessages: Decodable {
    
    var path: String
    var envelopes: [Envelope]
    
}

struct ChatUpdateRead: Decodable {
    
    var path: String
    
}

typealias Inbox = [String: Mailbox]

struct Mailbox: Decodable {
    
    var config: MailboxConfig
    var envelopes: [Envelope]
    
}

struct MailboxConfig: Decodable {
    
    var length: Int
    var read: Int
    
}

struct Envelope: Codable {

    var uid: String
    var number: Int
    var author: Ship
    var when: Date
    var letter: Letter
    
}

enum Letter: Codable {
    
    case text(LetterText)
    case url(LetterURL)
    case code(LetterCode)
    case me(LetterMe)
    
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
            self = .text(try container.decode(LetterText.self, forKey: .text))
        case [.url]:
            self = .url(try container.decode(LetterURL.self, forKey: .url))
        case [.code]:
            self = .code(try container.decode(LetterCode.self, forKey: .code))
        case [.me]:
            self = .me(try container.decode(LetterMe.self, forKey: .me))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        let container = try encoder.container(keyedBy: CodingKeys.self)
        switch self {
            
        }
    }
    
}

typealias LetterText = String

typealias LetterURL = String

struct LetterCode: Codable {
    
    var expression: String
    var output: [[String]]
    
}

typealias LetterMe = String
