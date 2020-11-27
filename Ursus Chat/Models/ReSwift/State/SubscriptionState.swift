//
//  SubscriptionState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import UrsusHTTP
import UrsusAPI

#warning("TODO: Eventually find a better solution than this protocol soup")

struct SubscriptionState: StateType, ChatHookState, ChatViewState, ContactViewState, GraphStoreState, GroupStoreState, InviteStoreState, MetadataStoreState {
    
    var inbox: Inbox = [:]
    var synced: Synced = [:]
    var invites: Invites = [:]
    var groups: Groups = [:]
    var contacts: Rolodex = [:]
    var associations: Associations = [:]
    
    var graphs: Graphs = [:]
    var graphKeys: Set<String> = []
    
    var pendingMessages: [Path: [Envelope]] = [:]
    var loadingMessages: [Path: Bool] = [:]
    
}
