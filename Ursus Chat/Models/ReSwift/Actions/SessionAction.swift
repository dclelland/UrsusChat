//
//  SessionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import Ursus

enum SessionAction: Action {

    case login(client: Ursus)
    case logout

}

#warning("TODO: Throw error on invalid state")

let sessionReducer: StateReducer<SessionAction, SessionState> = { action, state in
    switch (action, state) {
    case (.login(let client), .unauthenticated):
        state = .authenticated(client: client)
    case (.logout, .authenticated(let client)):
        state = .unauthenticated(credentials: SessionState.Credentials(url: client.url.absoluteString, code: client.code.description))
    default:
        fatalError("Invalid SessionState")
    }
}
