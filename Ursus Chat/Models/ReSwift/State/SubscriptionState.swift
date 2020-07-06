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
    var synced: ChatHookUpdate = [:]
    var invites: InviteStoreApp.Invites = [:]
    var contacts: ContactStoreApp.Rolodex = [:]
    
//    initialState() {
//      return {
//        inbox: {},
//        chatSynced: null,
//        contacts: {},
//        permissions: {},
//        invites: {},
//        associations: {
//          chat: {},
//          contacts: {}
//        },
//        sidebarShown: true,
//        pendingMessages: new Map([]),
//        chatInitialized: false,
//        s3: {}
//      };
//    }
    
}
