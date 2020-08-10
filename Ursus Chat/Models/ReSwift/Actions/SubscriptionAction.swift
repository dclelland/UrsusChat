//
//  SubscriptionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import UrsusAirlock

protocol SubscriptionAction: Action {
    
    func reduce(_ state: inout SubscriptionState) throws
    
}

enum SubscriptionActionError: Error {
    
    case unhandledEventUpdate(Any)
    
}

struct SubscriptionEventAction<Value>: SubscriptionAction {
    
    var event: SubscribeEvent<Result<Value, Error>>
    
    func reduce(_ state: inout SubscriptionState) throws {
        switch event {
        case .started:
            break
        case .update(.success(let value as ChatViewApp.SubscribeResponse)):
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
                    state.pendingMessages[message.path]?.removeAll { envelope in
                        envelope == message.envelope
                    }
                case .messages(let messages):
                    if let mailbox = state.inbox[messages.path] {
                        state.inbox[messages.path]?.envelopes = mailbox.envelopes + messages.envelopes
                    }
                    state.loadingMessages[messages.path] = nil
                case .read(let read):
                    if let mailbox = state.inbox[read.path] {
                        state.inbox[read.path]?.config.read = mailbox.config.length
                    }
                }
            }
        case .update(.success(let value as ChatHookApp.SubscribeResponse)):
            switch value {
            case .chatHookUpdate(let update):
                state.synced = update
            }
        case .update(.success(let value as InviteStoreApp.SubscribeResponse)):
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
        case .update(.success(let value as GroupStoreApp.SubscribeResponse)):
            switch value {
            case .groupUpdate(let update):
                switch update {
                case .initial(let initial):
                    state.groups = initial
                case .addGroup(let addGroup):
                    state.groups[addGroup.resource.path] = Group(
                        hidden: addGroup.hidden,
                        tags: [:],
                        members: [],
                        policy: addGroup.policy
                    )
                case .addMembers(let addMembers):
                    for ship in addMembers.ships {
                        state.groups[addMembers.resource.path]?.members.insert(ship)
                    }
                case .removeMembers(let removeMembers):
                    for ship in removeMembers.ships {
                        state.groups[removeMembers.resource.path]?.members.remove(ship)
                    }
                case .addTag:
                    break
                case .removeTag:
                    break
                case .changePolicy(let changePolicy):
                    switch (state.groups[changePolicy.resource.path]?.policy, changePolicy.diff) {
                    case (.open(var policy), .open(.allowRanks(let diff))):
                        policy.banRanks = policy.banRanks.subtracting(diff)
                        state.groups[changePolicy.resource.path]?.policy = .open(policy)
                    case (.open(var policy), .open(.banRanks(let diff))):
                        policy.banRanks = policy.banRanks.union(diff)
                        state.groups[changePolicy.resource.path]?.policy = .open(policy)
                    case (.open(var policy), .open(.allowShips(let diff))):
                        policy.banned = policy.banned.subtracting(diff)
                        state.groups[changePolicy.resource.path]?.policy = .open(policy)
                    case (.open(var policy), .open(.banShips(let diff))):
                        policy.banned = policy.banned.union(diff)
                        state.groups[changePolicy.resource.path]?.policy = .open(policy)
                    case (.invite(var policy), .invite(.addInvites(let diff))):
                        policy.pending = policy.pending.union(diff)
                        state.groups[changePolicy.resource.path]?.policy = .invite(policy)
                    case (.invite(var policy), .invite(.removeInvites(let diff))):
                        policy.pending = policy.pending.subtracting(diff)
                        state.groups[changePolicy.resource.path]?.policy = .invite(policy)
                    case (_, .replace(let diff)):
                        state.groups[changePolicy.resource.path]?.policy = diff
                    default:
                        break
                    }
                case .removeGroup(let removeGroup):
                    state.groups[removeGroup.resource.path] = nil
                case .expose:
                    break
                case .initialGroup(let initialGroup):
                    state.groups[initialGroup.resource.path] = initialGroup.group
                }
            }
        case .update(.success(let value as ContactViewApp.SubscribeResponse)):
            switch value {
            case .contactUpdate(let update):
                switch update {
                case .initial(let initial):
                    state.contacts = initial.mapValues { contacts in
                        return Dictionary(
                            uniqueKeysWithValues: contacts.compactMap { ship, contact in
                                return (try? Ship(string: ship)).map { ship in
                                    return (ship, contact)
                                }
                            }
                        )
                    }
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
                case .contacts:
                    break
                }
            }
        case .update(.success(let value as MetadataStoreApp.SubscribeResponse)):
            switch value {
            case .metadataUpdate(let update):
                switch update {
                case .initial(let initial):
                    #warning("TODO: This action should be idempotent; but be careful, the responses for \"app\" and \"contacts\" come in as separate `.initial` updates")
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
        case .update(.success(let value)):
            throw SubscriptionActionError.unhandledEventUpdate(value)
        case .update(.failure(let error)):
            throw error
        case .finished:
            break
        case .failure(let error):
            throw error
        }
    }
    
}

struct SubscriptionAddPendingMessageAction: SubscriptionAction {
    
    var path: Path
    
    var envelope: Envelope
    
    func reduce(_ state: inout SubscriptionState) throws {
        state.pendingMessages[path, default: []].insert(envelope, at: 0)
    }
    
}

struct SubscriptionRemovePendingMessageAction: SubscriptionAction {
    
    var path: Path
    
    var envelope: Envelope
    
    func reduce(_ state: inout SubscriptionState) throws {
        state.pendingMessages[path]?.removeAll { envelope in
            envelope == self.envelope
        }
    }
    
}

struct SubscriptionAddLoadingMessagesAction: SubscriptionAction {
    
    var path: Path
    
    func reduce(_ state: inout SubscriptionState) throws {
        state.loadingMessages[path] = true
    }
    
}

struct SubscriptionRemoveLoadingMessagesAction: SubscriptionAction {
    
    var path: Path
    
    func reduce(_ state: inout SubscriptionState) throws {
        state.loadingMessages[path] = nil
    }
    
}
