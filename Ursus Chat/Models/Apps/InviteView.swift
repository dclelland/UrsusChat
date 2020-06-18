//
//  InviteView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func inviteView(ship: String) -> InviteView {
        return app(ship: ship, app: "invite-view")
    }
    
}

class InviteView: UrsusApp {
    
    @discardableResult func primary(handler: @escaping (SubscribeEvent<PrimaryResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
}

extension InviteView {
    
    enum PrimaryResponse: Decodable {
        
        case inviteInitial(InviteStore.Invites)
        case inviteUpdate(InviteStore.InviteUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case inviteInitial
            case inviteUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.inviteInitial]:
                self = .inviteInitial(try container.decode(InviteStore.Invites.self, forKey: .inviteInitial))
            case [.inviteUpdate]:
                self = .inviteUpdate(try container.decode(InviteStore.InviteUpdate.self, forKey: .inviteUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
