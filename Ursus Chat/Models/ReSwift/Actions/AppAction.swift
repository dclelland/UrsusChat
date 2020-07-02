//
//  AppAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk
import Ursus

#warning("TODO: Set up keychain retrieval action")
#warning("TODO: Set up error/exception handling action")

enum AppAction: Action {
    
    case session(SessionAction)
    case subscription(SubscriptionAction)
    
}

let appReducer: StateReducer<AppAction, AppState> = { action, state in
    switch action {
    case .session(let action):
        sessionReducer(action, &state.session)
    case .subscription(let action):
        subscriptionReducer(action, &state.subscription)
    }
}

func loginAction(url: URL, code: Code) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        #warning("TODO: Should pull the login state out here")
        guard let state = getState() else {
            return
        }
        
        let client = Ursus(url: url, code: code)
        #warning("TODO: Dispatch 'loginStart' login action")
        client.loginRequest { ship in
            
            dispatch(AppAction.session(.login(client: client)))
            #warning("TODO: Dispatch 'loginSuccess' or 'loginFailure' login actions (loginFailure should be reset using an alert view)")
            #warning("TODO: DRY up event handlers")
            client.chatView(ship: ship).primary { event in
                if let value = event.value {
                    appStore.dispatch(AppAction.subscription(.update(.chatView(value))))
                }
            }.response { response in
                client.chatHook(ship: ship).synced { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.subscription(.update(.chatHook(value))))
                    }
                }
                client.inviteStore(ship: ship).all { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.subscription(.update(.inviteStore(value))))
                    }
                }
                client.permissionStore(ship: ship).all { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.subscription(.update(.permissionStore(value))))
                    }
                }
                client.contactView(ship: ship).primary { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.subscription(.update(.contactView(value))))
                    }
                }
                client.metadataStore(ship: ship).appName(app: "chat") { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.subscription(.update(.metadataStore(value))))
                    }
                }
                client.metadataStore(ship: ship).appName(app: "contacts") { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.subscription(.update(.metadataStore(value))))
                    }
                }
            }
        }
        
    }
    
}
