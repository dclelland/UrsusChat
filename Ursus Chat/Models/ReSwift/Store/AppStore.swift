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

class AppStore: ObservableStore<AppState> {
    
    static let shared = AppStore()
    
    convenience init(state: AppState = AppState()) {
        self.init(
            reducer: appReducer,
            state: AppState(),
            middleware: [
                createLoggerMiddleware(),
                createThunkMiddleware()
            ]
        )
    }
    
}

enum AppStoreError: LocalizedError {
    
    case unhandledAction(Action)
    
    var errorDescription: String? {
        switch self {
        case .unhandledAction(let action):
            return "Unhandled action: \(type(of: action))"
        }
    }
    
}

let appReducer: Reducer<AppState> = { action, state in
    var state = state ?? AppState()
    do {
        switch action {
        case let action as AppAction:
            try action.reduce(&state)
        case let action as SessionAction:
            try action.reduce(&state.session)
        case let action as ConnectionAction:
            try action.reduce(&state.connection)
        case let action as SubscriptionAction:
            try action.reduce(&state.subscription)
        default:
            throw AppStoreError.unhandledAction(action)
        }
    } catch let error {
        DispatchQueue.main.async {
            AppStore.shared.dispatch(AppErrorAction(error: error))
        }
    }
    return state
}
