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
import UrsusAirlock

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
            case .contactUpdate(let update):
                switch update {
                case .initial(let initial):
                    state.contacts = initial
                case .create(let create):
                    state.contacts[create] = [:]
                case .delete(let delete):
                    state.contacts[delete] = nil
                case .add(let add):
                    state.contacts[add.path]?[add.ship] = add.contact
                case .remove(let remove):
                    state.contacts[remove.path]?[remove.ship] = nil
                case .edit(let edit):
                    switch edit.editField {
                    case .nickname(let nickname):
                        state.contacts[edit.path]?[edit.ship]?.nickname = nickname
                    case .email(let email):
                        state.contacts[edit.path]?[edit.ship]?.email = email
                    case .phone(let phone):
                        state.contacts[edit.path]?[edit.ship]?.phone = phone
                    case .website(let website):
                        state.contacts[edit.path]?[edit.ship]?.website = website
                    case .notes(let notes):
                        state.contacts[edit.path]?[edit.ship]?.notes = notes
                    case .color(let color):
                        state.contacts[edit.path]?[edit.ship]?.color = color
                    case .avatar(let avatar):
                        state.contacts[edit.path]?[edit.ship]?.avatar = avatar
                    }
                case .contacts(let contacts):
                    break
                }
            }
        case .update(let value as MetadataStoreApp.AppNameResponse):
            switch value {
            case .metadataUpdate(let update):
                switch update {
                case .initial(let initial):
                    for association in initial.values {
                        state.associations[association.appName, default: [:]][association.appPath] = association
                    }
                case .add(let add):
                    state.associations[add.appName, default: [:]][add.appPath] = add
                case .update(let update):
                    state.associations[update.appName, default: [:]][update.appPath] = update
                case .remove(let remove):
                    state.associations[remove.appName]?[remove.appPath] = nil
                }
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
