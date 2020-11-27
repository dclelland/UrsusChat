//
//  SessionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import UrsusHTTP

protocol SessionAction: Action {
    
    func reduce(_ state: inout SessionState) throws
    
}

struct SessionLoginStartAction: SessionAction {
    
    func reduce(_ state: inout SessionState) throws {
        state = .authenticating
    }
    
}

struct SessionLoginFailureAction: SessionAction {
    
    func reduce(_ state: inout SessionState) throws {
        state = .unauthenticated
    }
    
}

struct SessionLoginFinishAction: SessionAction {
    
    var client: Client
    
    var ship: Ship
    
    func reduce(_ state: inout SessionState) throws {
        state = .authenticated(client: client, ship: ship)
    }
    
}
