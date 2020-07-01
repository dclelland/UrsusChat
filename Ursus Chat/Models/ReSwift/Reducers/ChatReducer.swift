//
//  ChatReducer.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import Ursus

enum ChatAction: Action {
    
    case chatViewResponse(ChatViewApp.PrimaryResponse)
    case chatHookResponse(ChatHookApp.SyncedResponse)
    case inviteStoreResponse(InviteStoreApp.AllResponse)
    case permissionStoreResponse(PermissionStoreApp.AllResponse)
    case contactViewResponse(ContactViewApp.PrimaryResponse)
    case metadataStoreResponse(MetadataStoreApp.AppNameResponse)
    
}

let chatReducer: StateReducer<ChatAction, ChatState> = { action, state in
    var state = state
    switch action {
    case .chatViewResponse(.chatInitial(let initial)):
        state.inbox = initial
    case .chatViewResponse(.chatUpdate(.create(let create))):
        state.inbox[create.path] = ChatStoreApp.Mailbox(config: ChatStoreApp.Config(length: 0, read: 0), envelopes: [])
    case .chatViewResponse(.chatUpdate(.delete(let delete))):
        state.inbox[delete.path] = nil
    case .chatViewResponse(.chatUpdate(.message(let message))):
        if let mailbox = state.inbox[message.path] {
            state.inbox[message.path]?.envelopes = [message.envelope] + mailbox.envelopes
            state.inbox[message.path]?.config.length = mailbox.config.length + 1
        }
    case .chatViewResponse(.chatUpdate(.read(let read))):
        if let mailbox = state.inbox[read.path] {
            state.inbox[read.path]?.config.read = mailbox.config.length
        }
    case .chatHookResponse(.chatHookUpdate(let update)):
        state.chatSynced = update
    case .inviteStoreResponse(.inviteInitial(let initial)):
        state.invites = initial
    case .inviteStoreResponse(.inviteUpdate(let update)):
        break
    case .permissionStoreResponse(.permissionInitial(let initial)):
        break
    case .permissionStoreResponse(.permissionUpdate(.create(let create))):
        break
    case .permissionStoreResponse(.permissionUpdate(.delete(let delete))):
        break
    case .permissionStoreResponse(.permissionUpdate(.add(let add))):
        break
    case .permissionStoreResponse(.permissionUpdate(.remove(let remove))):
        break
    case .contactViewResponse(.contactInitial(let initial)):
        break
    case .contactViewResponse(.contactUpdate(let update)):
        break
    case .metadataStoreResponse(.metadataUpdate(.associations(let associations))):
        break
    }
    return state
}
