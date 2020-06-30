//
//  MetadataStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func metadataStore(ship: Ship) -> MetadataStoreApp {
        return app(ship: ship, app: "metadata-store")
    }
    
}

class MetadataStoreApp: UrsusApp {
    
    @discardableResult func appName(app: String, handler: @escaping (SubscribeEvent<AppNameResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/app-name/\(app)", handler: handler)
    }
    
}

extension MetadataStoreApp {
    
    enum AppNameResponse: Decodable {
        
        case metadataUpdate(MetadataUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case metadataUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.metadataUpdate]:
                self = .metadataUpdate(try container.decode(MetadataUpdate.self, forKey: .metadataUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}

extension MetadataStoreApp {
    
    typealias Associations = [String: Association]
    
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
        var creator: String
        
    }
    
    enum MetadataUpdate: Decodable {
        
        #warning("Implement decoder for MetadataStoreApp.MetadataUpdate: Several cases remaining")
        
        case associations(Associations)
        
        enum CodingKeys: String, CodingKey {
            
            case associations
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.associations]:
                self = .associations(try container.decode(Associations.self, forKey: .associations))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
