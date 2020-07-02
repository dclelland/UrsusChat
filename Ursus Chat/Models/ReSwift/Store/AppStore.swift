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

typealias AppStore = ObservableStore<AppState>

enum AppStoreError: Error {
    
    case unhandledAction(Action)
    
}

let appStore = AppStore(
    reducer: appReducer,
    state: AppState(
        session: .unauthenticated(
            credentials: SessionState.Credentials(
                url: "http://192.168.1.78:8080",
                code: "lacnyd-morped-pilbel-pocnep"
            )
        )
    ),
    middleware: [
        createLoggerMiddleware(),
        createThunkMiddleware()
    ]
)

let appReducer: Reducer<AppState> = { action, state in
    var state = state ?? AppState()
    do {
        switch action {
        case let action as AppAction:
            try action.reduce(&state)
        case let action as SessionAction:
            try action.reduce(&state.session)
        case let action as SubscriptionAction:
            try action.reduce(&state.subscription)
        default:
            throw AppStoreError.unhandledAction(action)
        }
    } catch let error {
        DispatchQueue.main.async {
            appStore.dispatch(AppErrorAction(error: error))
        }
    }
    return state
}
