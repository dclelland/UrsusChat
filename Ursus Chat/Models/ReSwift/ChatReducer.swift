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
    
}

private func chatHookReducer(response: ChatHook.SyncedResponse, state: inout ChatState) {
    
}

private func inviteStoreReducer(response: InviteStore.AllResponse, state: inout ChatState) {
    
}

private func permissionStoreReducer(response: PermissionStore.AllResponse, state: inout ChatState) {
    
}

private func contactViewReducer(response: ContactView.PrimaryResponse, state: inout ChatState) {
    
}

private func metadataStoreReducer(response: MetadataStore.AppNameResponse, state: inout ChatState) {
    
}
