//
//  UnauthenticatedReducer.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

enum UnauthenticatedAction: Action {
    
    case loginAction(LoginAction)
    
}

let unauthenticatedReducer: StateReducer<UnauthenticatedAction, UnauthenticatedState> = { action, state in
    var state = state
    switch action {
    case .loginAction(let action):
        state.loginState = loginReducer(action, state.loginState)
    }
    return state
}
