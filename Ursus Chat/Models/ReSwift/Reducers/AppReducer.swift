//
//  AppReducer.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

enum AppAction: Action {
    
    case login(LoginAction)
    case chat(ChatAction)
    
}

let appReducer: StateReducer<AppAction, AppState> = { action, state in
    switch (action, state) {
    case (.login(let action), .login(let state)):
        return .login(loginReducer(action, state))
    case (.chat(let action), .chat(let state)):
        return .chat(chatReducer(action, state))
    default:
        return state
    }
}
