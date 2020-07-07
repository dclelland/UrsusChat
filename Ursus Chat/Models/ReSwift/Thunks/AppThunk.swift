//
//  AppThunk.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 7/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import KeychainAccess
import ReSwiftThunk
import Ursus

typealias AppThunk = Thunk<AppState>

extension AppThunk {
    
    static func startSession(credentials: UrsusCredentials) -> AppThunk {
        return AppThunk { dispatch, getState in
            let client = Ursus(credentials: credentials)
            client.loginRequest { ship in
                dispatch(SessionLoginAction(client: client))
                dispatch(AppThunk.startSubscription(client: client, ship: ship))
                dispatch(AppThunk.setCredentials(credentials))
            }.response { response in
                if let error = response.error {
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }

    static func startSubscription(client: Ursus, ship: Ship) -> AppThunk {
        return AppThunk { dispatch, getState in
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
        }
    }
    
}

extension AppThunk {
    
    private static let credentialsKey = "Credentials"
    
    static func getCredentials() -> AppThunk {
        return AppThunk { dispatch, getState in
            do {
                if let credentials = try Keychain.shared.decodeData(UrsusCredentials.self, key: credentialsKey) {
                    dispatch(AppThunk.startSession(credentials: credentials))
                }
            } catch let error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }
    
    static func setCredentials(_ credentials: UrsusCredentials) -> AppThunk {
        return AppThunk { dispatch, getState in
            do {
                try Keychain.shared.encodeData(credentials, key: credentialsKey)
            } catch let error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }
    
    static func clearCredentials() -> AppThunk {
        return AppThunk { dispatch, getState in
            do {
                try Keychain.shared.remove(credentialsKey)
            } catch let error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }
    
}
