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
import UrsusAirlock

typealias AppThunk = Thunk<AppState>

extension AppThunk {
    
    static func startSession(credentials: AirlockCredentials) -> AppThunk {
        return AppThunk { dispatch, getState in
            dispatch(SessionLoginStartAction())
            let airlock = Airlock(credentials: credentials)
            airlock.loginRequest { ship in
                dispatch(SessionLoginFinishAction(airlock: airlock))
                dispatch(AppThunk.startSubscription(airlock: airlock, ship: ship))
                dispatch(AppThunk.setCredentials(credentials))
            }.response { response in
                if let error = response.error {
                    dispatch(SessionLoginFailureAction())
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }

    static func startSubscription(airlock: Airlock, ship: Ship) -> AppThunk {
        return AppThunk { dispatch, getState in
            airlock.chatView(ship: ship).primary { event in
                dispatch(SubscriptionEventAction(event: event))
            }.response { response in
                airlock.chatHook(ship: ship).synced { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                airlock.inviteStore(ship: ship).all { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                airlock.permissionStore(ship: ship).all { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                airlock.contactView(ship: ship).primary { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                airlock.metadataStore(ship: ship).appName(app: "chat") { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                airlock.metadataStore(ship: ship).appName(app: "contacts") { event in
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
                if let credentials = try Keychain.shared.decodeData(AirlockCredentials.self, key: credentialsKey) {
                    dispatch(AppThunk.startSession(credentials: credentials))
                }
            } catch let error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }
    
    static func setCredentials(_ credentials: AirlockCredentials) -> AppThunk {
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
