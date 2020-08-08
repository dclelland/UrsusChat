//
//  SubscriptionState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import UrsusAirlock

struct SubscriptionState: StateType {
    
    var inbox: Inbox = [:]
    var synced: Synced = [:]
    var invites: Invites = [:]
    var groups: Groups = [:]
    var contacts: Rolodex = [:]
    var associations: Associations = [:]
    
    var pendingMessages: [Path: [Envelope]] = [:]
    var loadingMessages: [Path: Bool] = [:]
    
    var errors: [Error] = []
    
}
