//
//  InviteStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func inviteStore(ship: Ship) -> InviteStore {
        return app(ship: ship, app: "invite-store")
    }
    
}

class InviteStore: UrsusApp {
    
    @discardableResult func all(handler: @escaping (SubscribeEvent<AllResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}

extension InviteStore {
    
    enum AllResponse: Decodable {
        
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

extension InviteStore {
    
    struct Invite: Decodable {
        
        var ship: String
        var app: String
        var path: String
        var recipient: String
        var text: String
        
    }
    
    typealias Invites = [String: Invitatory]
    
    typealias Invitatory = [String: Invite]
    
    enum InviteBase: Decodable {
        
        struct Create: Decodable {
            
            var path: String
            
        }
        
        struct Delete: Decodable {
            
            var path: String
            
        }
        
        struct Invite: Decodable {
            
            var path: String
            var uid: String
            var invite: InviteStore.Invite
            
        }
        
        struct Decline: Decodable {
            
            var path: String
            var uid: String
            
        }
        
        case create(Create)
        case delete(Delete)
        case invite(Invite)
        case decline(Decline)
        
        enum CodingKeys: String, CodingKey {
            
            case create
            case delete
            case invite
            case decline
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.create]:
                self = .create(try container.decode(Create.self, forKey: .create))
            case [.delete]:
                self = .delete(try container.decode(Delete.self, forKey: .delete))
            case [.invite]:
                self = .invite(try container.decode(Invite.self, forKey: .invite))
            case [.decline]:
                self = .decline(try container.decode(Decline.self, forKey: .decline))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
    struct InviteAction: Decodable {

        #warning("Implement decoder for InviteStore.InviteAction")

    }
    
    struct InviteUpdate: Decodable {
        
        #warning("Implement decoder for InviteStore.InviteUpdate")
        
    }

}
