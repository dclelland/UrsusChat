//
//  AppReducer.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk
import Ursus

enum AppAction: Action {
    
    case loginSuccess(client: Ursus)
    
    case unauthenticatedAction(UnauthenticatedAction)
    case authenticatedAction(AuthenticatedAction)
    
}

let appReducer: StateReducer<AppAction, AppState> = { action, state in
    switch (action, state) {
    case (.loginSuccess(let client), .unauthenticatedState):
        return .authenticatedState(AuthenticatedState(client: client, chatState: ChatState()))
    case (.unauthenticatedAction(let action), .unauthenticatedState(let state)):
        return .unauthenticatedState(unauthenticatedReducer(action, state))
    case (.authenticatedAction(let action), .authenticatedState(let state)):
        return .authenticatedState(authenticatedReducer(action, state))
    default:
        return state
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
            
            dispatch(AppAction.loginSuccess(client: client))
            #warning("TODO: Dispatch 'loginSuccess' or 'loginFailure' login actions (loginFailure should be reset using an alert view)")
            #warning("TODO: DRY up event handlers")
            client.chatView(ship: ship).primary { event in
                if let value = event.value {
                    appStore.dispatch(AppAction.authenticatedAction(.chatAction(.chatViewResponse(value))))
                }
            }.response { response in
                client.chatHook(ship: ship).synced { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.authenticatedAction(.chatAction(.chatHookResponse(value))))
                    }
                }
                client.inviteStore(ship: ship).all { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.authenticatedAction(.chatAction(.inviteStoreResponse(value))))
                    }
                }
                client.permissionStore(ship: ship).all { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.authenticatedAction(.chatAction(.permissionStoreResponse(value))))
                    }
                }
                client.contactView(ship: ship).primary { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.authenticatedAction(.chatAction(.contactViewResponse(value))))
                    }
                }
                client.metadataStore(ship: ship).appName(app: "chat") { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.authenticatedAction(.chatAction(.metadataStoreResponse(value))))
                    }
                }
                client.metadataStore(ship: ship).appName(app: "contacts") { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.authenticatedAction(.chatAction(.metadataStoreResponse(value))))
                    }
                }
            }
        }
        
    }
    
}
