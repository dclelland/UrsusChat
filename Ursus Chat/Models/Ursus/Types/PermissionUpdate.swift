//
//  PermissionUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Ursus

enum PermissionUpdate: Decodable {
    
    case initial(PermissionUpdateInitial)
    case create(PermissionUpdateCreate)
    case delete(PermissionUpdateDelete)
    case add(PermissionUpdateAdd)
    case remove(PermissionUpdateRemove)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case create
        case delete
        case add
        case remove
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(PermissionUpdateInitial.self, forKey: .initial))
        case [.create]:
            self = .create(try container.decode(PermissionUpdateCreate.self, forKey: .create))
        case [.delete]:
            self = .delete(try container.decode(PermissionUpdateDelete.self, forKey: .delete))
        case [.add]:
            self = .add(try container.decode(PermissionUpdateAdd.self, forKey: .add))
        case [.remove]:
            self = .remove(try container.decode(PermissionUpdateRemove.self, forKey: .remove))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

typealias PermissionUpdateInitial = Permissions

struct PermissionUpdateCreate: Decodable {
    
    var path: String
    var kind: PermissionKind
    var who: Set<PatP>
    
}

struct PermissionUpdateDelete: Decodable {
    
    var path: String
    
}

struct PermissionUpdateAdd: Decodable {
    
    var path: String
    var who: Set<PatP>
    
}

struct PermissionUpdateRemove: Decodable {
    
    var path: String
    var who: Set<PatP>
    
}

typealias Permissions = [String: Permission]

struct Permission: Decodable {
    
    var who: Set<PatP>
    var kind: PermissionKind
    
}

enum PermissionKind: String, Decodable {
    
    case white
    case black
    
}
