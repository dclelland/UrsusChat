//
//  SessionState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import UrsusAirlock

enum SessionState: StateType {
    
    case unauthenticated
    case authenticating
    case authenticated(airlock: Airlock, ship: Ship)
    
    init() {
        self = .unauthenticated
    }
    
}
