//
//  PermissionStoreApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Airlock {
    
    func permissionStore(ship: Ship) -> PermissionStoreApp {
        return app(ship: ship, app: "permission-store")
    }
    
}

class PermissionStoreApp: AirlockApp {
    
    @discardableResult func all(handler: @escaping (SubscribeEvent<AllResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}

extension PermissionStoreApp {
    
    enum AllResponse: Decodable {
        
        case permissionUpdate(PermissionUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case permissionUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.permissionUpdate]:
                self = .permissionUpdate(try container.decode(PermissionUpdate.self, forKey: .permissionUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
