//
//  GroupUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

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

#warning("TODO: Finish GroupUpdate types")

typealias GroupUpdateInitial = Data
typealias GroupUpdateAddGroup = Data
typealias GroupUpdateAddMembers = Data
typealias GroupUpdateRemoveMembers = Data
typealias GroupUpdateAddTag = Data
typealias GroupUpdateRemoveTag = Data
typealias GroupUpdateChangePolicy = Data
typealias GroupUpdateRemoveGroup = Data
typealias GroupUpdateExpose = Data
typealias GroupUpdateInitialGroup = Data

typealias Groups = [String: String]

//import { PatpNoSig, Path, Jug, ShipRank, Enc } from './noun';
//
//export const roleTags = ['janitor', 'moderator', 'admin'] as const;
//export type RoleTags = typeof roleTags[number];
//interface RoleTag {
//  tag: 'admin' | 'moderator' | 'janitor';
//}
//
//interface AppTag {
//  app: string;
//  tag: string;
//}
//
//export type Tag = AppTag | RoleTag;
//
//export interface InvitePolicy {
//  invite: {
//    pending: Set<PatpNoSig>;
//  };
//}
//
//export interface OpenPolicy {
//  open: {
//    banned: Set<PatpNoSig>;
//    banRanks: Set<ShipRank>;
//  };
//}
//
//export interface Resource {
//  name: string;
//  ship: PatpNoSig;
//}
//
//export type OpenPolicyDiff =
//  | AllowRanksDiff
//  | BanRanksDiff
//  | AllowShipsDiff
//  | BanShipsDiff;
//
//interface AllowRanksDiff {
//  allowRanks: ShipRank[];
//}
//
//interface BanRanksDiff {
//  banRanks: ShipRank[];
//}
//
//interface AllowShipsDiff {
//  allowShips: PatpNoSig[];
//}
//
//interface BanShipsDiff {
//  banShips: PatpNoSig[];
//}
//
//export type InvitePolicyDiff = AddInvitesDiff | RemoveInvitesDiff;
//
//interface AddInvitesDiff {
//  addInvites: PatpNoSig[];
//}
//
//interface RemoveInvitesDiff {
//  removeInvites: PatpNoSig[];
//}
//
//interface ReplacePolicyDiff {
//  replace: GroupPolicy;
//}
//
//export type GroupPolicyDiff =
//  | { open: OpenPolicyDiff }
//  | { invite: InvitePolicyDiff }
//  | ReplacePolicyDiff;
//
//export type GroupPolicy = OpenPolicy | InvitePolicy;
//
//interface TaggedShips {
//  [tag: string]: Set<PatpNoSig>;
//}
//
//export interface Tags {
//  role: TaggedShips;
//  [app: string]: TaggedShips;
//}
//
//export interface Group {
//  members: Set<PatpNoSig>;
//  tags: Tags;
//  policy: GroupPolicy;
//  hidden: boolean;
//}
//
//export type Groups = {
//  [p in Path]: Group;
//};
//
//interface GroupUpdateInitial {
//  initial: Enc<Groups>;
//}
//
//interface GroupUpdateAddGroup {
//  addGroup: {
//    resource: Resource;
//    policy: Enc<GroupPolicy>;
//    hidden: boolean;
//  };
//}
//
//interface GroupUpdateAddMembers {
//  addMembers: {
//    ships: PatpNoSig[];
//    resource: Resource;
//  };
//}
//
//interface GroupUpdateRemoveMembers {
//  removeMembers: {
//    ships: PatpNoSig[];
//    resource: Resource;
//  };
//}
//
//interface GroupUpdateAddTag {
//  addTag: {
//    tag: Tag;
//    resource: Resource;
//    ships: PatpNoSig[];
//  };
//}
//
//interface GroupUpdateRemoveTag {
//  removeTag: {
//    tag: Tag;
//    resource: Resource;
//    ships: PatpNoSig;
//  };
//}
//
//interface GroupUpdateChangePolicy {
//  changePolicy: { resource: Resource; diff: GroupPolicyDiff };
//}
//
//interface GroupUpdateRemoveGroup {
//  removeGroup: {
//    resource: Resource;
//  };
//}
//
//interface GroupUpdateExpose {
//  expose: {
//    resource: Resource;
//  };
//}
//
//interface GroupUpdateInitialGroup {
//  initialGroup: {
//    resource: Resource;
//    group: Enc<Group>;
//  };
//}
//
//export type GroupUpdate =
//  | GroupUpdateInitial
//  | GroupUpdateAddGroup
//  | GroupUpdateAddMembers
//  | GroupUpdateRemoveMembers
//  | GroupUpdateAddTag
//  | GroupUpdateRemoveTag
//  | GroupUpdateChangePolicy
//  | GroupUpdateRemoveGroup
//  | GroupUpdateExpose
//  | GroupUpdateInitialGroup;
//
//export type GroupAction = Omit<GroupUpdate, 'initialGroup' | 'initial'>;
//
//export const groupBunts = {
//  group: (): Group => ({ members: new Set(), tags: { role: {} }, hidden: false, policy: groupBunts.policy() }),
//  policy: (): GroupPolicy => ({ open: { banned: new Set(), banRanks: new Set() } })
//};
