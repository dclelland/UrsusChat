//
//  GraphUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 20/11/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

struct TextContent: Decodable {
    
    var text: String
    
}

struct URLContent: Decodable {
    
    var url: String
    
}

struct CodeContent: Decodable {
    
    var expression: String
    var output: String
    
}

struct ReferenceContent: Decodable {
    
    var uid: String
    
}

struct MentionContent: Decodable {
    
    var mention: String
    
}

enum Content: Decodable {
    
    #warning("There might not be an explicit type key we can switch on here")
    
    case text(TextContent)
    case url(URLContent)
    case code(CodeContent)
    case reference(ReferenceContent)
    case mention(MentionContent)
    
    enum CodingKeys: String, CodingKey {
        
        case text
        case url
        case code
        case reference
        case mention
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.text]:
            self = .text(try container.decode(TextContent.self, forKey: .text))
        case [.url]:
            self = .url(try container.decode(URLContent.self, forKey: .url))
        case [.code]:
            self = .code(try container.decode(CodeContent.self, forKey: .code))
        case [.reference]:
            self = .reference(try container.decode(ReferenceContent.self, forKey: .reference))
        case [.mention]:
            self = .mention(try container.decode(MentionContent.self, forKey: .mention))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

struct Post: Decodable {
    
    #warning("Review these properties; is 'pending' the correct type or even necessary?")
    
    var author: Ship
    var contents: [Content]
    var hash: String?
    var index: String
    var pending: Bool?
    var signatures: [String]
    var timeSent: Int
    
    enum CodingKeys: String, CodingKey {
        
        case author
        case contents
        case hash
        case index
        case pending
        case signatures
        case timeSent = "time-sent"
        
    }
    
}

struct GraphNode: Decodable {
    
    var children: Graph
    var post: Post
    
}

#warning("This might need a full-blown custom collection type, see: https://github.com/urbit/urbit/blob/master/pkg/interface/src/logic/lib/BigIntOrderedMap.ts")

typealias Graph = [Int: GraphNode]

#warning("Review this ('export type Graphs = { [rid: string]: Graph };')")

typealias Graphs = [String: Graph]
