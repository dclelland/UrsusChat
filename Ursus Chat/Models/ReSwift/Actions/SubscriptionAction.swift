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
        case .update(let value as ChatViewApp.Primary):
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
        case .update(let value as ChatHookApp.Synced):
            switch value {
            case .chatHookUpdate(let update):
                state.synced = update
            }
        case .update(let value as InviteStoreApp.All):
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
        case .update(let value as GroupStoreApp.Groups):
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
                case .addTag(let addTag):
                    break
                case .removeTag(let removeTag):
                    break
                case .changePolicy(let changePolicy):
                    break
                case .removeGroup(let removeGroup):
                    state.groups[removeGroup.resource.path] = nil
                case .expose(let expose):
                    break
                case .initialGroup(let initialGroup):
                    state.groups[initialGroup.resource.path] = initialGroup.group
                }
            }
        case .update(let value as ContactViewApp.Primary):
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
                case .contacts(let contacts):
                    break
                }
            }
        case .update(let value as MetadataStoreApp.AppName):
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

//import _ from 'lodash';
//import { StoreState } from '../store/type';
//import { Cage } from '../types/cage';
//import {
//  GroupUpdate,
//  Group,
//  Tags,
//  GroupPolicy,
//  GroupPolicyDiff,
//  OpenPolicyDiff,
//  OpenPolicy,
//  InvitePolicyDiff,
//  InvitePolicy,
//} from '../types/group-update';
//import { Enc, PatpNoSig } from '../types/noun';
//import { resourceAsPath } from '../lib/util';
//
//type GroupState = Pick<StoreState, 'groups' | 'groupKeys'>;
//
//function decodeGroup(group: Enc<Group>): Group {
//  const members = new Set(group.members);
//  const res = {
//    ...group,
//    members,
//    tags: decodeTags(group.tags),
//    policy: decodePolicy(group.policy),
//  };
//  console.log(res);
//  return res;
//}
//
//function decodePolicy(policy: Enc<GroupPolicy>): GroupPolicy {
//  if ('invite' in policy) {
//    const { invite } = policy;
//    return { invite: { pending: new Set(invite.pending) } };
//  } else {
//    const { open } = policy;
//    return {
//      open: { banned: new Set(open.banned), banRanks: new Set(open.banRanks) },
//    };
//  }
//}
//
//function decodeTags(tags: Enc<Tags>): Tags {
//  return _.reduce(
//    tags,
//    (acc, tag, key): Tags => {
//      if (Array.isArray(tag)) {
//        acc.role[key] = new Set(tag);
//        return acc;
//      } else {
//        const app = _.reduce(
//          tag,
//          (inner, t, k) => {
//            inner[k] = new Set(t);
//            return inner;
//          },
//          {}
//        );
//        acc[key] = app;
//        return acc;
//      }
//    },
//    { role: {} }
//  );
//}
//
//export default class GroupReducer<S extends GroupState> {
//  reduce(json: Cage, state: S) {
//    const data = json.groupUpdate;
//    if (data) {
//      this.initial(data, state);
//      this.addMembers(data, state);
//      this.addTag(data, state);
//      this.removeMembers(data, state);
//      this.initialGroup(data, state);
//      this.removeTag(data, state);
//      this.initial(data, state);
//      this.addGroup(data, state);
//      this.removeGroup(data, state);
//      this.changePolicy(data, state);
//    }
//  }
//
//  initial(json: GroupUpdate, state: S) {
//    const data = json['initial'];
//    if (data) {
//      state.groups = _.mapValues(data, decodeGroup);
//    }
//  }
//
//  initialGroup(json: GroupUpdate, state: S) {
//    if ('initialGroup' in json) {
//      const { resource, group } = json.initialGroup;
//      const path = resourceAsPath(resource);
//      state.groups[path] = decodeGroup(group);
//    }
//  }
//
//  addGroup(json: GroupUpdate, state: S) {
//    if ('addGroup' in json) {
//      const { resource, policy, hidden } = json.addGroup;
//      const resourcePath = resourceAsPath(resource);
//      state.groups[resourcePath] = {
//        members: new Set(),
//        tags: { role: {} },
//        policy: decodePolicy(policy),
//        hidden,
//      };
//    }
//  }
//  removeGroup(json: GroupUpdate, state: S) {
//    if('removeGroup' in json) {
//      const { resource } = json.removeGroup;
//      const resourcePath = resourceAsPath(resource);
//      delete state.groups[resourcePath];
//    }
//  }
//
//  addMembers(json: GroupUpdate, state: S) {
//    if ('addMembers' in json) {
//      const { resource, ships } = json.addMembers;
//      const resourcePath = resourceAsPath(resource);
//      for (const member of ships) {
//        state.groups[resourcePath].members.add(member);
//      }
//    }
//  }
//
//  removeMembers(json: GroupUpdate, state: S) {
//    if ('removeMembers' in json) {
//      const { resource, ships } = json.removeMembers;
//      const resourcePath = resourceAsPath(resource);
//      for (const member of ships) {
//        state.groups[resourcePath].members.delete(member);
//      }
//    }
//  }
//
//  addTag(json: GroupUpdate, state: S) {
//    if ('addTag' in json) {
//      const { resource, tag, ships } = json.addTag;
//      const resourcePath = resourceAsPath(resource);
//      const tags = state.groups[resourcePath].tags;
//      const tagAccessors =
//        'app' in tag ? [tag.app,tag.tag] :  ['role', tag.tag];
//      const tagged = _.get(tags, tagAccessors, new Set());
//      for (const ship of ships) {
//        tagged.add(ship);
//      }
//      _.set(tags, tagAccessors, tagged);
//    }
//  }
//
//  removeTag(json: GroupUpdate, state: S) {
//    if ('removeTag' in json) {
//      const { resource, tag, ships } = json.removeTag;
//      const resourcePath = resourceAsPath(resource);
//      const tags = state.groups[resourcePath].tags;
//      const tagAccessors =
//        'app' in tag ? [tag.app,tag.tag] :  ['role', tag.tag];
//      const tagged = _.get(tags, tagAccessors, new Set());
//
//      if (!tagged) {
//        return;
//      }
//      for (const ship of ships) {
//        tagged.delete(ship);
//      }
//      _.set(tags, tagAccessors, tagged);
//    }
//  }
//
//  changePolicy(json: GroupUpdate, state: S) {
//    if ('changePolicy' in json && state) {
//      const { resource, diff } = json.changePolicy;
//      const resourcePath = resourceAsPath(resource);
//      const policy = state.groups[resourcePath].policy;
//      if ('open' in policy && 'open' in diff) {
//        this.openChangePolicy(diff.open, policy);
//      } else if ('invite' in policy && 'invite' in diff) {
//        this.inviteChangePolicy(diff.invite, policy);
//      } else if ('replace' in diff) {
//        state.groups[resourcePath].policy = diff.replace;
//      } else {
//        console.log('bad policy diff');
//      }
//    }
//  }
//
//  private inviteChangePolicy(diff: InvitePolicyDiff, policy: InvitePolicy) {
//    if ('addInvites' in diff) {
//      const { addInvites } = diff;
//      for (const ship of addInvites) {
//        policy.invite.pending.add(ship);
//      }
//    } else if ('removeInvites' in diff) {
//      const { removeInvites } = diff;
//      for (const ship of removeInvites) {
//        policy.invite.pending.delete(ship);
//      }
//    } else {
//      console.log('bad policy change');
//    }
//  }
//
//  private openChangePolicy(diff: OpenPolicyDiff, policy: OpenPolicy) {
//    if ('allowRanks' in diff) {
//      const { allowRanks } = diff;
//      for (const rank of allowRanks) {
//        policy.open.banRanks.delete(rank);
//      }
//    } else if ('banRanks' in diff) {
//      const { banRanks } = diff;
//      for (const rank of banRanks) {
//        policy.open.banRanks.delete(rank);
//      }
//    } else if ('allowShips' in diff) {
//      console.log('allowing ships');
//      const { allowShips } = diff;
//      for (const ship of allowShips) {
//        policy.open.banned.delete(ship);
//      }
//    } else if ('banShips' in diff) {
//      console.log('banning ships');
//      const { banShips } = diff;
//      for (const ship of banShips) {
//        policy.open.banned.add(ship);
//      }
//    } else {
//      console.log('bad policy change');
//    }
//  }
//}
