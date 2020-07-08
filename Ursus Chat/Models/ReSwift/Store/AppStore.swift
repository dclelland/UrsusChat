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

extension AppStore {
    
    static let shared = AppStore()
    
    static let preview = AppStore(
        state: AppState(
            subscription: SubscriptionState(
                inbox: [
                    "/~fipfes-fipfes/preview-chat": Mailbox(
                        config: MailboxConfig(
                            length: 0,
                            read: 0
                        ),
                        envelopes: [
                            Envelope(
                                uid: "0",
                                number: 0,
                                author: "~fipfes-fipfes",
                                when: Date(),
                                letter: .text("Hello")
                            )
                        ]
                    )
                ],
                contacts: [
                    "/~fipfes-fipfes/preview-chat": [
                        "fipfes-fipfes": Contact(
                            nickname: "Fipfes Fipfes",
                            email: "",
                            phone: "",
                            website: "",
                            notes: "",
                            color: "0x0",
                            avatar: nil
                        )
                    ]
                ],
                associations: [
                    "chat": [
                        "/~fipfes-fipfes/preview-chat": Association(
                            groupPath: "/~fipfes-fipfes/preview-chat",
                            appName: "chat",
                            appPath: "/~fipfes-fipfes/preview-chat",
                            metadata: Metadata(
                                title: "Preview chat",
                                description: "Preview chat description",
                                color: "0x0",
                                dateCreated: "~2020.1.1..00.00.00..0000",
                                creator: "~fipfes-fipfes"
                            )
                        )
                    ]
                ]
            )
        )
    )
    
}

enum AppStoreError: Error {
    
    case unhandledAction(Action)
    
}

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
            AppStore.shared.dispatch(AppErrorAction(error: error))
        }
    }
    return state
}
