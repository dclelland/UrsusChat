//
//  GraphUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 20/11/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

enum GraphUpdate: Decodable {
    
    case keys(GraphUpdateKeys)
    case addGraph(GraphUpdateAddGraph)
    case removeGraph(GraphUpdateRemoveGraph)
    case addNodes(GraphUpdateAddNodes)
    case removeNodes(GraphUpdateRemoveNodes)
    
    enum CodingKeys: String, CodingKey {
        
        case keys
        case addGraph = "add-graph"
        case removeGraph = "remove-graph"
        case addNodes = "add-nodes"
        case removeNodes = "remove-nodes"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.keys]:
            self = .keys(try container.decode(GraphUpdateKeys.self, forKey: .keys))
        case [.addGraph]:
            self = .addGraph(try container.decode(GraphUpdateAddGraph.self, forKey: .addGraph))
        case [.removeGraph]:
            self = .removeGraph(try container.decode(GraphUpdateRemoveGraph.self, forKey: .removeGraph))
        case [.addNodes]:
            self = .addNodes(try container.decode(GraphUpdateAddNodes.self, forKey: .addNodes))
        case [.removeNodes]:
            self = .removeNodes(try container.decode(GraphUpdateRemoveNodes.self, forKey: .removeNodes))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

typealias GraphUpdateKeys = [Resource]

struct GraphUpdateAddGraph: Decodable {
    
    #warning("TODO: Finish GraphUpdateAddGraph; review `graph` type")
    
    var graph: [Graph]
    var resource: Resource
    var mark: Mark
    var overwrite: Bool
    
}

struct GraphUpdateRemoveGraph: Decodable {
    
    #warning("TODO: Finish GraphUpdateRemoveGraph")
    
}

struct GraphUpdateAddNodes: Decodable {
    
    #warning("TODO: Finish GraphUpdateAddNodes")
    
}

struct GraphUpdateRemoveNodes: Decodable {
    
    #warning("TODO: Finish GraphUpdateRemoveNodes")
    
}


/* ---------------------------------- */

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

struct Resource: Decodable {
    
    var ship: Ship
    var name: String
    
}

struct GraphNode: Decodable {
    
    var children: Graph
    var post: Post
    
}

#warning("This might need a full-blown custom collection type, see: https://github.com/urbit/urbit/blob/master/pkg/interface/src/logic/lib/BigIntOrderedMap.ts; also see: https://github.com/lukaskubanek/OrderedDictionary; perhaps add a basic atom (`@`) type to UrsusAtom")

typealias Graph = [Int: GraphNode]

#warning("Review this ('export type Graphs = { [rid: string]: Graph };')")

typealias Graphs = [String: Graph]
