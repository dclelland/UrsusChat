//
//  SessionAction.swift
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

protocol SessionAction: Action {
    
    func reduce(_ state: inout SessionState) throws
    
}

enum SessionActionError: Error {
    
    case alreadyLoggedIn
    case alreadyLoggedOut
    
}

struct SessionLoginAction: SessionAction {
    
    var client: Ursus
    
    func reduce(_ state: inout SessionState) throws {
        switch state {
        case .unauthenticated:
            state = .authenticated(client: client)
        case .authenticated:
            throw SessionActionError.alreadyLoggedIn
        }
    }
    
}

struct SessionLogoutAction: SessionAction {
    
    func reduce(_ state: inout SessionState) throws {
        switch state {
        case .unauthenticated:
            throw SessionActionError.alreadyLoggedOut
        case .authenticated(let client):
            state = .unauthenticated(credentials: SessionState.Credentials(url: client.url.absoluteString, code: client.code.description))
        }
    }
    
}

func sessionLoginThunk(url: URL, code: Code) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        #warning("TODO: Should pull the login state out here")
        guard let state = getState() else {
            return
        }

        let client = Ursus(url: url, code: code)
        #warning("TODO: Dispatch 'loginStart' login action")
        client.loginRequest { ship in
            dispatch(SessionLoginAction(client: client))
            #warning("TODO: Dispatch 'loginSuccess' or 'loginFailure' login actions (loginFailure should be reset using an alert view)")
            client.chatView(ship: ship).primary { event in
                dispatch(SubscriptionEventAction(event: event))
            }.response { response in
                client.chatHook(ship: ship).synced { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.inviteStore(ship: ship).all { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.permissionStore(ship: ship).all { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.contactView(ship: ship).primary { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.metadataStore(ship: ship).appName(app: "chat") { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.metadataStore(ship: ship).appName(app: "contacts") { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
            }
        }.response { response in
            if let error = response.error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }

}
