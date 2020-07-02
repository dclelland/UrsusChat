//
//  AppState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    
    var session: SessionState = .unauthenticated()
    var subscription: SubscriptionState = SubscriptionState()
    var errors: [Error] = []
    
}
