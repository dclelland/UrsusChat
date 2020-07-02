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
    
    #warning("TODO: Remove default credentials")
    
    var session: SessionState = .unauthenticated(credentials: SessionState.Credentials(url: "http://192.168.1.78:8080", code: "lacnyd-morped-pilbel-pocnep"))
    var subscription: SubscriptionState = SubscriptionState()
    
}
