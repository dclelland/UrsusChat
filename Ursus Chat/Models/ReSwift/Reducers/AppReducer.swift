//
//  AppReducer.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

typealias MyReducer<ReducerAction: Action, ReducerStateType: StateType> = (_ action: ReducerAction, _ state: ReducerStateType) -> ReducerStateType

enum AppAction: Action {
    
    case login(LoginAction)
    case chat(ChatAction)
    
}

let appReducer: MyReducer<AppAction, AppState> = { action, state in
    switch (action, state) {
    case (.login(let action), .login(let state)):
        return .login(loginReducer(action, state))
    case (.chat(let action), .chat(let state)):
        return .chat(chatReducer(action, state))
    default:
        return state
    }
}
