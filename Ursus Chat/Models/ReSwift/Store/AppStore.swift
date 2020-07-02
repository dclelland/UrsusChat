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

typealias StateReducer<ReducerAction: Action, ReducerStateType: StateType> = (_ action: ReducerAction, _ state: inout ReducerStateType) -> Void

typealias AppStore = ObservableStore<AppState>

let appStore = AppStore(
    store: Store(
        reducer: { action, state in
            var state = state ?? AppState()
            switch action {
            case let action as AppAction:
                appReducer(action, &state)
            default:
                break
            }
            return state
        },
        state: AppState(),
        middleware: [
            createLoggerMiddleware(),
            createThunkMiddleware()
        ]
    )
)
