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

extension ChatView.PrimaryResponse: Action { }

extension ChatHook.SyncedResponse: Action { }

extension InviteStore.AllResponse: Action { }

extension PermissionStore.AllResponse: Action { }

extension ContactView.PrimaryResponse: Action { }

extension MetadataStore.AppNameResponse: Action { }

let chatReducer: Reducer<ChatState> = { action, state in
    var state = state ?? ChatState()
    
    switch action {
    case SubscribeEvent<ChatView.PrimaryResponse>.update(let response):
        chatViewReducer(response: response, state: &state)
    case SubscribeEvent<ChatHook.SyncedResponse>.update(let response):
        chatHookReducer(response: response, state: &state)
    case SubscribeEvent<InviteStore.AllResponse>.update(let response):
        inviteStoreReducer(response: response, state: &state)
    case SubscribeEvent<PermissionStore.AllResponse>.update(let response):
        permissionStoreReducer(response: response, state: &state)
    case SubscribeEvent<ContactView.PrimaryResponse>.update(let response):
        contactViewReducer(response: response, state: &state)
    case SubscribeEvent<MetadataStore.AppNameResponse>.update(let response):
        metadataStoreReducer(response: response, state: &state)
    default:
        break
    }

    return state
}

private func chatViewReducer(response: ChatView.PrimaryResponse, state: inout ChatState) {
    switch response {
    case .chatInitial(let initial):
        state.inbox = initial
    case .chatUpdate(let update):
        switch update {
        case .create(let create):
            state.inbox[create.path] = ChatStore.Mailbox(config: ChatStore.Config(length: 0, read: 0), envelopes: [])
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

private func chatHookReducer(response: ChatHook.SyncedResponse, state: inout ChatState) {
    switch response {
    case .chatHookUpdate(let update):
        state.chatSynced = update
    }
}

private func inviteStoreReducer(response: InviteStore.AllResponse, state: inout ChatState) {
    switch response {
    case .inviteInitial(let initial):
        state.invites = initial
    case .inviteUpdate(let update):
        break
    }
}

private func permissionStoreReducer(response: PermissionStore.AllResponse, state: inout ChatState) {
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

private func contactViewReducer(response: ContactView.PrimaryResponse, state: inout ChatState) {
    switch response {
    case .contactInitial(let initial):
        state.contacts = initial
    case .contactUpdate(let update):
        break
    }
}

private func metadataStoreReducer(response: MetadataStore.AppNameResponse, state: inout ChatState) {
    switch response {
    case .metadataUpdate(let update):
        switch update {
        case .associations(let associations):
            break
        }
    }
}