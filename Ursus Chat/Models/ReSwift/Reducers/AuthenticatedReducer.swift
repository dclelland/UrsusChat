//
//  AuthenticatedReducer.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

enum AuthenticatedAction: Action {
    
    case chatAction(ChatAction)
    
}

let authenticatedReducer: StateReducer<AuthenticatedAction, AuthenticatedState> = { action, state in
    var state = state
    switch action {
    case .chatAction(let action):
        state.chatState = chatReducer(action, state.chatState)
    }
    return state
}
