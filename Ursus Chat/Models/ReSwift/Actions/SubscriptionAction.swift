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
            client.inviteStore(ship: ship).all { event in
                dispatch(SubscriptionEventAction(event: event))
            }
            client.permissionStore(ship: ship).all { event in
                dispatch(SubscriptionEventAction(event: event))
            }
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
                case .initial(let initial):
                    state.inbox = initial
                case .create(let create):
                    state.inbox[create] = Mailbox(
                        config: MailboxConfig(
                            length: 0,
                            read: 0
                        ),
                        envelopes: []
                    )
                case .delete(let delete):
                    state.inbox[delete] = nil
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
            case .inviteUpdate(let update):
                switch update {
                case .initial(let initial):
                    state.invites = initial
                case .create(let create):
                    state.invites[create.path] = [:]
                case .delete(let delete):
                    state.invites[delete.path] = nil
                case .invite(let invite):
                    state.invites[invite.path]?[invite.uid] = invite.invite
                case .accepted(let accepted):
                    state.invites[accepted.path]?[accepted.uid] = nil
                case .decline(let decline):
                    state.invites[decline.path]?[decline.uid] = nil
                }
            }
        case .update(let value as PermissionStoreApp.AllResponse):
            switch value {
            case .permissionUpdate(let update):
                switch update {
                case .initial(let initial):
                    state.permissions = initial
                case .create(let create):
                    state.permissions[create.path] = Permission(
                        who: create.who,
                        kind: create.kind
                    )
                case .delete(let delete):
                    state.permissions[delete.path] = nil
                case .add(let add):
                    for member in add.who {
                        state.permissions[add.path]?.who.insert(member)
                    }
                case .remove(let remove):
                    for member in remove.who {
                        state.permissions[remove.path]?.who.remove(member)
                    }
                }
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
