//
//  SessionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import UrsusAirlock

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
    
    var airlock: Airlock
    
    var ship: Ship
    
    func reduce(_ state: inout SessionState) throws {
        state = .authenticated(airlock: airlock, ship: ship)
    }
    
}

struct SessionLogoutAction: SessionAction {
    
    func reduce(_ state: inout SessionState) throws {
        state = .unauthenticated
    }
    
}
