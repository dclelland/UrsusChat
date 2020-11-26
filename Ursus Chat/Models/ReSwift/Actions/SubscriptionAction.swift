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

enum SubscriptionActionError: LocalizedError {
    
    case unhandledEventUpdate(Any)
    
    var errorDescription: String? {
        switch self {
        case .unhandledEventUpdate(let value):
            return "Unhandled event update: \(type(of: value))"
        }
    }
    
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
                    state.inbox[create.path] = Mailbox(
                        config: MailboxConfig(
                            length: 0,
                            read: 0
                        ),
                        envelopes: []
                    )
                case .delete(let delete):
                    state.inbox[delete.path] = nil
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
                    state.associations = [:]
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
        case .update(.success(let value as GraphStoreApp.SubscribeResponse)):
            switch value {
            case .graphUpdate(let update):
                switch update {
                case .keys(let resources):
                    #warning("TODO: Is the Ship.Prefixless conversion necessary here?")
                    state.graphKeys = Set(
                        resources.map { resource in
                            return resource.description
                        }
                    )
                    print(state.graphKeys)
                case .addGraph(let addGraph):
                    #warning("TODO: Finish graph store reducer (addGraph)")
                    
//                    const addGraph = (json, state) => {
//
//                      const _processNode = (node) => {
//                        //  is empty
//                        if (!node.children) {
//                          node.children = new BigIntOrderedMap();
//                          return node;
//                        }
//
//                        //  is graph
//                        let converted = new BigIntOrderedMap();
//                        for (let i in node.children) {
//                          let item = node.children[i];
//                          let index = item[0].split('/').slice(1).map((ind) => {
//                            return bigInt(ind);
//                          });
//
//                          if (index.length === 0) { break; }
//
//                          converted.set(
//                            index[index.length - 1],
//                            _processNode(item[1])
//                          );
//                        }
//                        node.children = converted;
//                        return node;
//                      };
//
//                      const data = _.get(json, 'add-graph', false);
//                      if (data) {
//                        if (!('graphs' in state)) {
//                          state.graphs = {};
//                        }
//
//                        let resource = data.resource.ship + '/' + data.resource.name;
//                        state.graphs[resource] = new BigIntOrderedMap();
//
//                        for (let i in data.graph) {
//                          let item = data.graph[i];
//                          let index = item[0].split('/').slice(1).map((ind) => {
//                            return bigInt(ind);
//                          });
//
//                          if (index.length === 0) { break; }
//
//                          let node = _processNode(item[1]);
//
//                          state.graphs[resource].set(
//                            index[index.length - 1],
//                            node
//                          );
//                        }
//                        state.graphKeys.add(resource);
//                      }
//
//                    };
                    
                    break
                case .removeGraph(let removeGraph):
                    #warning("TODO: Finish graph store reducer (removeGraph)")
                    
//                    const removeGraph = (json, state) => {
//                      const data = _.get(json, 'remove-graph', false);
//                      if (data) {
//                        if (!('graphs' in state)) {
//                          state.graphs = {};
//                        }
//                        let resource = data.ship + '/' + data.name;
//                        delete state.graphs[resource];
//                      }
//                    };
                    
                    break
                case .addNodes(let addNodes):
                    #warning("TODO: Finish graph store reducer (addNodes)")
                    
//                    const addNodes = (json, state) => {
//                      const _addNode = (graph, index, node) => {
//                        //  set child of graph
//                        if (index.length === 1) {
//                          graph.set(index[0], node);
//                          return graph;
//                        }
//
//                        // set parent of graph
//                        let parNode = graph.get(index[0]);
//                        if (!parNode) {
//                          console.error('parent node does not exist, cannot add child');
//                          return;
//                        }
//                        parNode.children = _addNode(parNode.children, index.slice(1), node);
//                        graph.set(index[0], parNode);
//                        return graph;
//                      };
//
//                      const data = _.get(json, 'add-nodes', false);
//                      if (data) {
//                        if (!('graphs' in state)) { return; }
//
//                        let resource = data.resource.ship + '/' + data.resource.name;
//                        if (!(resource in state.graphs)) { return; }
//
//                        for (let i in data.nodes) {
//                          let item = data.nodes[i];
//                          if (item[0].split('/').length === 0) { return; }
//
//                          let index = item[0].split('/').slice(1).map((ind) => {
//                            return bigInt(ind);
//                          });
//
//                          if (index.length === 0) { return; }
//
//                          item[1].children = mapifyChildren(item[1].children || []);
//
//                          state.graphs[resource] = _addNode(
//                            state.graphs[resource],
//                            index,
//                            item[1]
//                          );
//                        }
//                      }
//                    };
                    
//                    const mapifyChildren = (children) => {
//                      return new BigIntOrderedMap(
//                        children.map(([idx, node]) => {
//                          const nd = {...node, children: mapifyChildren(node.children || []) };
//                          return [bigInt(idx.slice(1)), nd];
//                        }));
//                    };
                    
                    break
                case .removeNodes(let removeNodes):
                    #warning("TODO: Finish graph store reducer (removeNodes)")
                    
//                    const removeNodes = (json, state) => {
//                      const _remove = (graph, index) => {
//                        if (index.length === 1) {
//                            graph.delete(index[0]);
//                          } else {
//                            const child = graph.get(index[0]);
//                            _remove(child.children, index.slice(1));
//                            graph.set(index[0], child);
//                          }
//                      };
//                      const data = _.get(json, 'remove-nodes', false);
//                      if (data) {
//                        const { ship, name } = data.resource;
//                        const res = `${ship}/${name}`;
//                        if (!(res in state.graphs)) { return; }
//
//                        data.indices.forEach((index) => {
//                          if (index.split('/').length === 0) { return; }
//                          let indexArr = index.split('/').slice(1).map((ind) => {
//                            return bigInt(ind);
//                          });
//                          _remove(state.graphs[res], indexArr);
//                        });
//                      }
//                    };
                    
                    break
                }
            }
            break
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
