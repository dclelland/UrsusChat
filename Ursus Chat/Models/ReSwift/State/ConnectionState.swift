//
//  ConnectionState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

enum ConnectionState: StateType {
    
    case ready
    case connecting
    case reconnecting
    case connected
    case disconnected(error: Error)
    
    init() {
        self = .ready
    }
    
}
