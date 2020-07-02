//
//  SubscriptionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import Ursus

protocol SubscriptionAction: Action {
    
    func reduce(_ state: inout SubscriptionState) throws
    
}

enum SubscriptionActionError: Error {
    
    case unhandledEventUpdate(Any)
    
}

struct SubscriptionEventAction<Value>: SubscriptionAction {
    
    var event: SubscribeEvent<Value>
    
    func reduce(_ state: inout SubscriptionState) throws {
        switch event {
        case .update(let value as ChatViewApp.PrimaryResponse):
            switch value {
            case .chatInitial(let initial):
                state.inbox = initial
            case .chatUpdate(.create(let create)):
                state.inbox[create.path] = ChatStoreApp.Mailbox(config: ChatStoreApp.Config(length: 0, read: 0), envelopes: [])
            case .chatUpdate(.delete(let delete)):
                state.inbox[delete.path] = nil
            case .chatUpdate(.message(let message)):
                if let mailbox = state.inbox[message.path] {
                    state.inbox[message.path]?.envelopes = [message.envelope] + mailbox.envelopes
                    state.inbox[message.path]?.config.length = mailbox.config.length + 1
                }
            case .chatUpdate(.read(let read)):
                if let mailbox = state.inbox[read.path] {
                    state.inbox[read.path]?.config.read = mailbox.config.length
                }
            }
        case .update(let value as ChatHookApp.SyncedResponse):
            switch value {
            case .chatHookUpdate(let update):
                state.synced = update
            }
        case .update(let value as InviteStoreApp.AllResponse):
            switch value {
            case .inviteInitial(let initial):
                state.invites = initial
            case .inviteUpdate(let update):
                break
            }
        case .update(let value as PermissionStoreApp.AllResponse):
            switch value {
            case .permissionInitial(let initial):
                break
            case .permissionUpdate(.create(let create)):
                break
            case .permissionUpdate(.delete(let delete)):
                break
            case .permissionUpdate(.add(let add)):
                break
            case .permissionUpdate(.remove(let remove)):
                break
            }
        case .update(let value as ContactViewApp.PrimaryResponse):
            switch value {
            case .contactInitial(let initial):
                break
            case .contactUpdate(let update):
                break
            }
        case .update(let value as MetadataStoreApp.AppNameResponse):
            switch value {
            case .metadataUpdate(.associations(let associations)):
                break
            }
        case .update(let value):
            throw SubscriptionActionError.unhandledEventUpdate(value)
        case .failure(let error):
            throw error
        default:
            break
        }
    }
    
}
