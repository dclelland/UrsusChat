//
//  ChatState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

struct ChatState: StateType {
    
    var inbox: ChatStore.Inbox = [:]
    var chatSynced: [String: String]? = nil
    
    var invites: InviteStore.Invites = [:]
    
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
