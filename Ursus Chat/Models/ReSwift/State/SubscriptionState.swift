//
//  SubscriptionState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import Ursus

struct SubscriptionState: StateType {
    
    var inbox: Inbox = [:]
    var synced: Synced = [:]
    var invites: Invites = [:]
    var permissions: Permissions = [:]
    var contacts: Rolodex = [:]
    var associations: Associations = [:]
    
}
