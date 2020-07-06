//
//  InviteStoreApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func inviteStore(ship: Ship) -> InviteStoreApp {
        return app(ship: ship, app: "invite-store")
    }
    
}

class InviteStoreApp: UrsusApp {
    
    @discardableResult func all(handler: @escaping (SubscribeEvent<AllResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}

extension InviteStoreApp {
    
    enum AllResponse: Decodable {
        
        case inviteUpdate(InviteUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case inviteUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.inviteUpdate]:
                self = .inviteUpdate(try container.decode(InviteUpdate.self, forKey: .inviteUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
