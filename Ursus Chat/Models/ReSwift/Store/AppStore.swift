//
//  AppStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk

typealias StateReducer<ReducerAction: Action, ReducerStateType: StateType> = (_ action: ReducerAction, _ state: ReducerStateType) -> ReducerStateType

typealias AppStore = ObservableStore<AppState>

let appStore = AppStore(
    store: Store(
        reducer: { action, state in
            switch (action, state) {
            case (let action as AppAction, .some(let state)):
                return appReducer(action, state)
            default:
                fatalError("State not initialized")
            }
        },
        state: .loginState(LoginState(url: "http://192.168.1.78:8080", code: "lacnyd-morped-pilbel-pocnep")),
        middleware: [
            createLoggerMiddleware(),
            createThunkMiddleware()
        ]
    )
)
