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
    
    case loginAction(LoginAction)
    case chatAction(ChatAction)
    
}

let appReducer: StateReducer<AppAction, AppState> = { action, state in
    switch (action, state) {
    case (.loginSuccess(let client), .loginState):
        return .chatState(ChatState())
    case (.loginAction(let action), .loginState(let state)):
        return .loginState(loginReducer(action, state))
    case (.chatAction(let action), .chatState(let state)):
        return .chatState(chatReducer(action, state))
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
        #warning("TODO: Dispatch 'authenticating' login event")
        client.loginRequest { ship in
            
            dispatch(AppAction.loginSuccess(client: client))
            #warning("TODO: Dispatch 'authenticated' login event")
            #warning("TODO: DRY up event handlers")
            client.chatView(ship: ship).primary { event in
                if let value = event.value {
                    appStore.dispatch(AppAction.chatAction(.chatViewResponse(value)))
                }
            }.response { response in
                client.chatHook(ship: ship).synced { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.chatAction(.chatHookResponse(value)))
                    }
                }
                client.inviteStore(ship: ship).all { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.chatAction(.inviteStoreResponse(value)))
                    }
                }
                client.permissionStore(ship: ship).all { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.chatAction(.permissionStoreResponse(value)))
                    }
                }
                client.contactView(ship: ship).primary { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.chatAction(.contactViewResponse(value)))
                    }
                }
                client.metadataStore(ship: ship).appName(app: "chat") { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.chatAction(.metadataStoreResponse(value)))
                    }
                }
                client.metadataStore(ship: ship).appName(app: "contacts") { event in
                    if let value = event.value {
                        appStore.dispatch(AppAction.chatAction(.metadataStoreResponse(value)))
                    }
                }
            }
        }
        
    }
    
}
