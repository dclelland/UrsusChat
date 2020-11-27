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
import UrsusHTTP
import UrsusAPI

typealias AppThunk = Thunk<AppState>

extension AppThunk {
    
    private static let credentialsKey = "Credentials"
    
    static func getCredentials() -> AppThunk {
        return AppThunk { dispatch, getState in
            do {
                if let credentials = try Keychain.shared.decodeData(Credentials.self, key: credentialsKey) {
                    dispatch(AppThunk.startSession(credentials: credentials))
                }
            } catch let error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }
    
    static func setCredentials(_ credentials: Credentials) -> AppThunk {
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

extension AppThunk {
    
    static func startSession(credentials: Credentials) -> AppThunk {
        return AppThunk { dispatch, getState in
            dispatch(SessionLoginStartAction())
            let client = Client(credentials: credentials)
            client.loginRequest { result in
                switch result {
                case .success(let ship):
                    dispatch(SessionLoginFinishAction(client: client, ship: ship))
                    dispatch(AppThunk.startSubscription(client: client, ship: ship))
                    dispatch(AppThunk.setCredentials(credentials))
                case .failure(let error):
                    dispatch(SessionLoginFailureAction())
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }
    
    static func stopSession(client: Client) -> AppThunk {
        return AppThunk { dispatch, getState in
            dispatch(AppThunk.clearCredentials())
            dispatch(AppDisconnectAction())
        }
    }
    
}

extension AppThunk {

    static func startSubscription(client: Client, ship: Ship) -> AppThunk {
        return AppThunk { dispatch, getState in
            func handler<Value>(event: SubscribeEvent<Result<Value, Error>>) {
                dispatch(SubscriptionEventAction(event: event))
            }
            
            dispatch(ConnectionStartAction())
            
            var alreadyDispatchedConnectionSuccessAction: Bool = false
            
            client.chatViewAgent(ship: ship).primarySubscribeRequest(handler: handler)
            client.chatHookAgent(ship: ship).syncedSubscribeRequest(handler: handler)
            client.inviteStoreAgent(ship: ship).allSubscribeRequest(handler: handler)
            client.groupStoreAgent(ship: ship).groupsSubscribeRequest(handler: handler)
            client.contactViewAgent(ship: ship).primarySubscribeRequest(handler: handler)
            client.metadataStoreAgent(ship: ship).allSubscribeRequest(handler: handler)
            client.graphStoreAgent(ship: ship).keysSubscribeRequest(handler: handler)
            client.graphStoreAgent(ship: ship).updatesSubscribeRequest(handler: handler)
            client.connect().responseStream { stream in
                switch stream.event {
                case .stream:
                    if alreadyDispatchedConnectionSuccessAction == false {
                        dispatch(ConnectionSuccessAction())
                        alreadyDispatchedConnectionSuccessAction = true
                    }
                case .complete(let completion):
                    if let error = completion.error {
                        dispatch(ConnectionFailureAction(error: error))
                    }
                }
            }
        }
    }
    
}

extension AppThunk {
    
    static func sendRead(path: Path) -> AppThunk {
        return AppThunk { dispatch, getState in
            guard case .authenticated(let client, let ship) = getState()?.session else {
                return
            }
            
            client.chatStoreAgent(ship: ship).readPokeRequest(path: path) { event in
                switch event {
                case .failure(let error):
                    dispatch(AppErrorAction(error: error))
                case .finished:
                    print("[AppThunk.sendRead] Poke finished")
                }
            }.response { response in
                if let error = response.error {
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }
    
    static func sendMessage(path: Path, letter: Letter) -> AppThunk {
        return AppThunk { dispatch, getState in
            guard case .authenticated(let client, let ship) = getState()?.session else {
                return
            }
            
            let envelope = Envelope(uid: UUID().patUVString, number: 0, author: ship, when: Date(), letter: letter)
            
            dispatch(SubscriptionAddPendingMessageAction(path: path, envelope: envelope))
            
            client.chatHookAgent(ship: ship).messagePokeRequest(path: path, envelope: envelope) { event in
                switch event {
                case .failure(let error):
                    dispatch(SubscriptionRemovePendingMessageAction(path: path, envelope: envelope))
                    dispatch(AppErrorAction(error: error))
                case .finished:
                    print("[AppThunk.sendMessage] Poke finished")
                }
            }.response { response in
                if let error = response.error {
                    dispatch(SubscriptionRemovePendingMessageAction(path: path, envelope: envelope))
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }
    
}

extension AppThunk {
    
    static func getMessages(path: Path, range: ClosedRange<Int>) -> AppThunk {
        return AppThunk { dispatch, getState in
            guard case .authenticated(let client, let ship) = getState()?.session else {
                return
            }
            
            dispatch(SubscriptionAddLoadingMessagesAction(path: path))
            
            client.chatViewAgent(ship: ship).messagesRequest(path: path, start: range.lowerBound, end: range.upperBound) { result in
                switch result {
                case .success(let response):
                    dispatch(SubscriptionEventAction(event: .update(.success(response))))
                case .failure(let error):
                    dispatch(SubscriptionRemoveLoadingMessagesAction(path: path))
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }
    
}
