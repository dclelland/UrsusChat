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

extension SubscribeEvent: Action where Value: Action { }

extension ChatViewApp.PrimaryResponse: Action { }

extension ChatHookApp.SyncedResponse: Action { }

extension InviteStoreApp.AllResponse: Action { }

extension PermissionStoreApp.AllResponse: Action { }

extension ContactViewApp.PrimaryResponse: Action { }

extension MetadataStoreApp.AppNameResponse: Action { }

let chatReducer: Reducer<ChatState> = { action, state in
    var state = state ?? ChatState()
    
    switch action {
    case SubscribeEvent<ChatViewApp.PrimaryResponse>.update(let response):
        chatViewReducer(response: response, state: &state)
    case SubscribeEvent<ChatHookApp.SyncedResponse>.update(let response):
        chatHookReducer(response: response, state: &state)
    case SubscribeEvent<InviteStoreApp.AllResponse>.update(let response):
        inviteStoreReducer(response: response, state: &state)
    case SubscribeEvent<PermissionStoreApp.AllResponse>.update(let response):
        permissionStoreReducer(response: response, state: &state)
    case SubscribeEvent<ContactViewApp.PrimaryResponse>.update(let response):
        contactViewReducer(response: response, state: &state)
    case SubscribeEvent<MetadataStoreApp.AppNameResponse>.update(let response):
        metadataStoreReducer(response: response, state: &state)
    default:
        break
    }

    return state
}

private func chatViewReducer(response: ChatViewApp.PrimaryResponse, state: inout ChatState) {
    switch response {
    case .chatInitial(let initial):
        state.inbox = initial
    case .chatUpdate(let update):
        switch update {
        case .create(let create):
            state.inbox[create.path] = ChatStoreApp.Mailbox(config: ChatStoreApp.Config(length: 0, read: 0), envelopes: [])
        case .delete(let delete):
            state.inbox[delete.path] = nil
        case .message(let message):
            if let mailbox = state.inbox[message.path] {
                state.inbox[message.path]?.envelopes = [message.envelope] + mailbox.envelopes
                state.inbox[message.path]?.config.length = mailbox.config.length + 1
            }
        case .read(let read):
            if let mailbox = state.inbox[read.path] {
                state.inbox[read.path]?.config.read = mailbox.config.length
            }
        }
    }
}

private func chatHookReducer(response: ChatHookApp.SyncedResponse, state: inout ChatState) {
    switch response {
    case .chatHookUpdate(let update):
        state.chatSynced = update
    }
}

private func inviteStoreReducer(response: InviteStoreApp.AllResponse, state: inout ChatState) {
    switch response {
    case .inviteInitial(let initial):
        state.invites = initial
    case .inviteUpdate(let update):
        break
    }
}

private func permissionStoreReducer(response: PermissionStoreApp.AllResponse, state: inout ChatState) {
    switch response {
    case .permissionInitial(let initial):
        break
    case .permissionUpdate(let update):
        switch update {
        case .create(let create):
            break
        case .delete(let delete):
            break
        case .add(let add):
            break
        case .remove(let remove):
            break
        }
    }
}

private func contactViewReducer(response: ContactViewApp.PrimaryResponse, state: inout ChatState) {
    switch response {
    case .contactInitial(let initial):
        state.contacts = initial
    case .contactUpdate(let update):
        break
    }
}

private func metadataStoreReducer(response: MetadataStoreApp.AppNameResponse, state: inout ChatState) {
    switch response {
    case .metadataUpdate(let update):
        switch update {
        case .associations(let associations):
            break
        }
    }
}
