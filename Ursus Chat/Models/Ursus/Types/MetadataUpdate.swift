//
//  MetadataUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Ursus

enum MetadataUpdate: Decodable {
    
    case initial(MetadataUpdateInitial)
    case add(MetadataUpdateAdd)
    case update(MetadataUpdateUpdate)
    case remove(MetadataUpdateRemove)
    
    enum CodingKeys: String, CodingKey {
        
        case initial = "associations"
        case add
        case update
        case remove
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(MetadataUpdateInitial.self, forKey: .initial))
        case [.add]:
            self = .add(try container.decode(MetadataUpdateAdd.self, forKey: .add))
        case [.update]:
            self = .update(try container.decode(MetadataUpdateUpdate.self, forKey: .update))
        case [.remove]:
            self = .remove(try container.decode(MetadataUpdateRemove.self, forKey: .remove))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

typealias MetadataUpdateInitial = AppAssociations

typealias MetadataUpdateAdd = Association

typealias MetadataUpdateUpdate = Association

struct MetadataUpdateRemove: Decodable {
    
    var groupPath: String
    var appPath: String
    var appName: String
    
}

typealias Associations = [String: AppAssociations]

typealias AppAssociations = [String: Association]

struct Association: Decodable {

    var groupPath: String
    var appName: String
    var appPath: String
    var metadata: Metadata

}

struct Metadata: Decodable {

    var title: String
    var description: String
    var color: String
    var dateCreated: String
    var creator: Ship

}
