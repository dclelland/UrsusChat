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

func chatReducer(action: Action, state: ChatState?) -> ChatState {
    var state = state ?? ChatState()
    
    print(action)
    
    switch action {
    case SubscribeEvent<ChatView.PrimaryResponse>.update(let value):
        break
    case SubscribeEvent<ChatHook.SyncedResponse>.update(let value):
        break
    case SubscribeEvent<InviteStore.AllResponse>.update(let value):
        break
    case SubscribeEvent<PermissionStore.AllResponse>.update(let value):
        break
    case SubscribeEvent<ContactView.PrimaryResponse>.update(let value):
        break
    case SubscribeEvent<MetadataStore.AppNameResponse>.update(let value):
        break
    default:
        break
    }

    return state
}

