//
//  SubscriptionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk
import Ursus

protocol SubscriptionAction: Action {
    
    func reduce(_ state: inout SubscriptionState) throws
    
}

enum SubscriptionActionError: Error {
    
    case unhandledEventUpdate(Any)
    
}

func subscriptionThunk(client: Ursus, ship: Ship) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        client.chatView(ship: ship).primary { event in
            dispatch(SubscriptionEventAction(event: event))
        }.response { response in
            client.chatHook(ship: ship).synced { event in
                dispatch(SubscriptionEventAction(event: event))
            }
//            client.inviteStore(ship: ship).all { event in
//                dispatch(SubscriptionEventAction(event: event))
//            }
//            client.permissionStore(ship: ship).all { event in
//                dispatch(SubscriptionEventAction(event: event))
//            }
//            client.contactView(ship: ship).primary { event in
//                dispatch(SubscriptionEventAction(event: event))
//            }
//            client.metadataStore(ship: ship).appName(app: "chat") { event in
//                dispatch(SubscriptionEventAction(event: event))
//            }
//            client.metadataStore(ship: ship).appName(app: "contacts") { event in
//                dispatch(SubscriptionEventAction(event: event))
//            }
        }
    }

}

struct SubscriptionEventAction<Value>: SubscriptionAction {
    
    var event: SubscribeEvent<Value>
    
    func reduce(_ state: inout SubscriptionState) throws {
        switch event {
        case .started:
            break
        case .update(let value as ChatViewApp.PrimaryResponse):
            switch value {
            case .chatUpdate(let update):
                switch update {
                case .initial(let inbox):
                    state.inbox = inbox
                case .create(let path):
                    state.inbox[path] = Mailbox(
                        config: MailboxConfig(
                            length: 0,
                            read: 0
                        ),
                        envelopes: []
                    )
                case .delete(let path):
                    state.inbox[path] = nil
                case .message(let message):
                    if let mailbox = state.inbox[message.path] {
                        state.inbox[message.path]?.envelopes = [message.envelope] + mailbox.envelopes
                        state.inbox[message.path]?.config.length = mailbox.config.length + 1
                    }
                case .messages(let messages):
                    if let mailbox = state.inbox[messages.path] {
                        state.inbox[messages.path]?.envelopes = messages.envelopes + mailbox.envelopes
                    }
                case .read(let read):
                    if let mailbox = state.inbox[read.path] {
                        state.inbox[read.path]?.config.read = mailbox.config.length
                    }
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
        case .finished:
            break
        case .failure(let error):
            throw error
        }
    }
    
}
