//
//  PermissionStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func permissionStore(ship: Ship) -> PermissionStore {
        return app(ship: ship, app: "permission-store")
    }
    
}

class PermissionStore: UrsusApp {
    
    @discardableResult func all(handler: @escaping (SubscribeEvent<AllResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}

extension PermissionStore {
    
    enum AllResponse: Decodable {
        
        case permissionInitial(PermissionMap)
        case permissionUpdate(PermissionUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case permissionInitial
            case permissionUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.permissionInitial]:
                self = .permissionInitial(try container.decode(PermissionStore.PermissionMap.self, forKey: .permissionInitial))
            case [.permissionUpdate]:
                self = .permissionUpdate(try container.decode(PermissionStore.PermissionUpdate.self, forKey: .permissionUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}


extension PermissionStore {
    
    enum Kind: String, Decodable {
        
        case black
        case white
        
    }
    
    struct Permission: Decodable {
        
        var kind: Kind
        var who: Set<String>
        
    }
    
    typealias PermissionMap = [String: Permission]
    
    enum PermissionUpdate: Decodable {
        
        struct Create: Decodable {
            
            var path: String
            var permission: Permission
            
        }
        
        struct Delete: Decodable {
            
            var path: String
            
        }
        
        struct Add: Decodable {
            
            var path: String
            var who: Set<String>
            
        }
        
        struct Remove: Decodable {
            
            var path: String
            var who: Set<String>
            
        }
        
        case create(Create)
        case delete(Delete)
        case add(Add)
        case remove(Remove)
        
        enum CodingKeys: String, CodingKey {
            
            case create
            case delete
            case add
            case remove
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.create]:
                self = .create(try container.decode(Create.self, forKey: .create))
            case [.delete]:
                self = .delete(try container.decode(Delete.self, forKey: .delete))
            case [.add]:
                self = .add(try container.decode(Add.self, forKey: .add))
            case [.remove]:
                self = .remove(try container.decode(Remove.self, forKey: .remove))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
    struct PermissionAction: Decodable {
        
        #warning("Implement decoder for PermissionStore.PermissionAction")
        
    }
    
}
