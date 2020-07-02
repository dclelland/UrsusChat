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

enum AppStoreError: Error {
    
    case unhandledAction(Action)
    
}

let appStore = AppStore()

let previewAppStore = AppStore(
    state: AppState(
        session: .unauthenticated(
            credentials: SessionState.Credentials(
                url: "http://localhost",
                code: "fipfes-fipfes-fipfes-fipfes"
            )
        ),
        subscription: SubscriptionState(
            inbox: [
                "Test Chat": ChatStoreApp.Mailbox(
                    config: ChatStoreApp.Config(
                        length: 0,
                        read: 0
                    ),
                    envelopes: [
                        ChatStoreApp.Envelope(
                            uid: "0",
                            number: 0,
                            author: "~fipfes-fipfes",
                            when: Date(),
                            letter: .text("Hello")
                        )
                    ]
                )
            ]
        )
    )
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
