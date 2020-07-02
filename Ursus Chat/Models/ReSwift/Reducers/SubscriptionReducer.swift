//
//  SubscriptionReducer.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import Ursus

enum SubscriptionAction: Action {
    
    enum Update {
        
        case chatView(ChatViewApp.PrimaryResponse)
        case chatHook(ChatHookApp.SyncedResponse)
        case inviteStore(InviteStoreApp.AllResponse)
        case permissionStore(PermissionStoreApp.AllResponse)
        case contactView(ContactViewApp.PrimaryResponse)
        case metadataStore(MetadataStoreApp.AppNameResponse)
        
    }
    
    case update(Update)
    
}

let subscriptionReducer: StateReducer<SubscriptionAction, SubscriptionState> = { action, state in
    switch action {
    case .update(let update):
        switch update {
        case .chatView(.chatInitial(let initial)):
            state.inbox = initial
        case .chatView(.chatUpdate(.create(let create))):
            state.inbox[create.path] = ChatStoreApp.Mailbox(config: ChatStoreApp.Config(length: 0, read: 0), envelopes: [])
        case .chatView(.chatUpdate(.delete(let delete))):
            state.inbox[delete.path] = nil
        case .chatView(.chatUpdate(.message(let message))):
            if let mailbox = state.inbox[message.path] {
                state.inbox[message.path]?.envelopes = [message.envelope] + mailbox.envelopes
                state.inbox[message.path]?.config.length = mailbox.config.length + 1
            }
        case .chatView(.chatUpdate(.read(let read))):
            if let mailbox = state.inbox[read.path] {
                state.inbox[read.path]?.config.read = mailbox.config.length
            }
        case .chatHook(.chatHookUpdate(let update)):
            state.synced = update
        case .inviteStore(.inviteInitial(let initial)):
            state.invites = initial
        case .inviteStore(.inviteUpdate(let update)):
            break
        case .permissionStore(.permissionInitial(let initial)):
            break
        case .permissionStore(.permissionUpdate(.create(let create))):
            break
        case .permissionStore(.permissionUpdate(.delete(let delete))):
            break
        case .permissionStore(.permissionUpdate(.add(let add))):
            break
        case .permissionStore(.permissionUpdate(.remove(let remove))):
            break
        case .contactView(.contactInitial(let initial)):
            break
        case .contactView(.contactUpdate(let update)):
            break
        case .metadataStore(.metadataUpdate(.associations(let associations))):
            break
        }
    }
}
