//
//  SubscriptionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import UrsusHTTP
import UrsusAPI

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
        case .update(.success(let response as ChatViewAgent.SubscribeResponse)):
            try UrsusAPI.reduce(state, response)
        case .update(.success(let response as ChatHookAgent.SubscribeResponse)):
            try UrsusAPI.reduce(&state, response)
        case .update(.success(let response as InviteStoreAgent.SubscribeResponse)):
            try UrsusAPI.reduce(&state, response)
        case .update(.success(let response as GroupStoreAgent.SubscribeResponse)):
            try UrsusAPI.reduce(&state, response)
        case .update(.success(let response as ContactViewAgent.SubscribeResponse)):
            try UrsusAPI.reduce(&state, response)
        case .update(.success(let response as MetadataStoreAgent.SubscribeResponse)):
            try UrsusAPI.reduce(&state, response)
        case .update(.success(let response as GraphStoreAgent.SubscribeResponse)):
            try UrsusAPI.reduce(&state, response)
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
