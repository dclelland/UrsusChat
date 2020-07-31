//
//  GroupUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

enum GroupUpdate: Decodable {
    
    case initial(GroupUpdateInitial)
    case addGroup(GroupUpdateAddGroup)
    case addMembers(GroupUpdateAddMembers)
    case removeMembers(GroupUpdateRemoveMembers)
    case addTag(GroupUpdateAddTag)
    case removeTag(GroupUpdateRemoveTag)
    case changePolicy(GroupUpdateChangePolicy)
    case removeGroup(GroupUpdateRemoveGroup)
    case expose(GroupUpdateExpose)
    case initialGroup(GroupUpdateInitialGroup)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case addGroup
        case addMembers
        case removeMembers
        case addTag
        case removeTag
        case changePolicy
        case removeGroup
        case expose
        case initialGroup
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(GroupUpdateInitial.self, forKey: .initial))
        case [.addGroup]:
            self = .addGroup(try container.decode(GroupUpdateAddGroup.self, forKey: .addGroup))
        case [.addMembers]:
            self = .addMembers(try container.decode(GroupUpdateAddMembers.self, forKey: .addMembers))
        case [.removeMembers]:
            self = .removeMembers(try container.decode(GroupUpdateRemoveMembers.self, forKey: .removeMembers))
        case [.addTag]:
            self = .addTag(try container.decode(GroupUpdateAddTag.self, forKey: .addTag))
        case [.removeTag]:
            self = .removeTag(try container.decode(GroupUpdateRemoveTag.self, forKey: .removeTag))
        case [.changePolicy]:
            self = .changePolicy(try container.decode(GroupUpdateChangePolicy.self, forKey: .changePolicy))
        case [.removeGroup]:
            self = .removeGroup(try container.decode(GroupUpdateRemoveGroup.self, forKey: .removeGroup))
        case [.expose]:
            self = .expose(try container.decode(GroupUpdateExpose.self, forKey: .expose))
        case [.initialGroup]:
            self = .initialGroup(try container.decode(GroupUpdateInitialGroup.self, forKey: .initialGroup))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

typealias GroupUpdateInitial = Groups

struct GroupUpdateAddGroup: Decodable {
    
    var resource: Resource
    var policy: GroupPolicy
    var hidden: Bool
    
}

struct GroupUpdateAddMembers: Decodable {
    
    var resource: Resource
    var ships: [Ship]
    
}

struct GroupUpdateRemoveMembers: Decodable {
    
    var resource: Resource
    var ships: [Ship]
    
}

struct GroupUpdateAddTag: Decodable {
    
    var tag: Tag
    var resource: Resource
    var ships: [Ship]
    
}

struct GroupUpdateRemoveTag: Decodable {
    
    var tag: Tag
    var resource: Resource
    var ships: [Ship]
    
}

struct GroupUpdateChangePolicy: Decodable {
    
    var resource: Resource
    var diff: GroupPolicyDiff
    
}

struct GroupUpdateRemoveGroup: Decodable {
    
    var resource: Resource
    
}

struct GroupUpdateExpose: Decodable {
    
    var resource: Resource
    
}

struct GroupUpdateInitialGroup: Decodable {
    
    var resource: Resource
    var group: Group
    
}

enum ShipRank: String, Decodable {
    
    case czar
    case king
    case duke
    case earl
    case pawn
    
}

typealias Groups = [Path: Group]

struct Group: Decodable {
    
    var hidden: Bool
    var tags: Tags
    var members: Set<Ship>
    var policy: GroupPolicy
    
}

struct Resource: Decodable {
    
    var name: String
    var ship: Ship
    
}

#warning("TODO: Fix this type; swap [String: TaggedShips] for [Tag: TaggedShips]; it also looks like TaggedShips can be an array *or* dictionary")

typealias Tags = [String: TaggedShips]

typealias TaggedShips = Data

enum Tag: Decodable {
    
    case app(AppTag)
    case role(RoleTag)
    
    init(from decoder: Decoder) throws {
        switch (Result { try AppTag(from: decoder) }, Result { try RoleTag(from: decoder) }) {
        case (.success(let appTag), .failure):
            self = .app(appTag)
        case (.failure, .success(let roleTag)):
            self = .role(roleTag)
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self))"))
        }
    }
    
}

struct AppTag: Decodable {
    
    var app: App
    var tag: String
    
}

enum RoleTag: String, Decodable {
    
    case admin
    case moderator
    case janitor
    
}

enum GroupPolicy: Decodable {
    
    case open(OpenPolicy)
    case invite(InvitePolicy)
    
    enum CodingKeys: String, CodingKey {
        
        case open
        case invite
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.open]:
            self = .open(try container.decode(OpenPolicy.self, forKey: .open))
        case [.invite]:
            self = .invite(try container.decode(InvitePolicy.self, forKey: .invite))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

struct InvitePolicy: Decodable {
    
    var pending: Set<Ship>
    
}

struct OpenPolicy: Decodable {
    
    var banned: Set<Ship>
    var banRanks: Set<ShipRank>
    
}

enum GroupPolicyDiff: Decodable {
    
    case open(OpenPolicyDiff)
    case invite(InvitePolicyDiff)
    case replace(ReplacePolicyDiff)
    
    enum CodingKeys: String, CodingKey {
        
        case open
        case invite
        case replace
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.open]:
            self = .open(try container.decode(OpenPolicyDiff.self, forKey: .open))
        case [.invite]:
            self = .invite(try container.decode(InvitePolicyDiff.self, forKey: .invite))
        case [.replace]:
            self = .replace(try container.decode(ReplacePolicyDiff.self, forKey: .replace))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

enum OpenPolicyDiff: Decodable {
    
    case allowRanks(AllowRanksDiff)
    case banRanks(BanRanksDiff)
    case allowShips(AllowShipsDiff)
    case banShips(BanShipsDiff)
    
    
    enum CodingKeys: String, CodingKey {
        
        case allowRanks
        case banRanks
        case allowShips
        case banShips
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.allowRanks]:
            self = .allowRanks(try container.decode(AllowRanksDiff.self, forKey: .allowRanks))
        case [.banRanks]:
            self = .banRanks(try container.decode(BanRanksDiff.self, forKey: .banRanks))
        case [.allowShips]:
            self = .allowShips(try container.decode(AllowShipsDiff.self, forKey: .allowShips))
        case [.banShips]:
            self = .banShips(try container.decode(BanShipsDiff.self, forKey: .banShips))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

typealias AllowRanksDiff = [ShipRank]

typealias BanRanksDiff = [ShipRank]

typealias AllowShipsDiff = [Ship]

typealias BanShipsDiff = [Ship]

enum InvitePolicyDiff: Decodable {
    
    case addInvites(AddInvitesDiff)
    case removeInvites(RemoveInvitesDiff)
    
    enum CodingKeys: String, CodingKey {
        
        case addInvites
        case removeInvites
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.addInvites]:
            self = .addInvites(try container.decode(AddInvitesDiff.self, forKey: .addInvites))
        case [.removeInvites]:
            self = .removeInvites(try container.decode(RemoveInvitesDiff.self, forKey: .removeInvites))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

typealias AddInvitesDiff = [Ship]

typealias RemoveInvitesDiff = [Ship]

typealias ReplacePolicyDiff = GroupPolicy
