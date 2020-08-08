//
//  ConnectionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

protocol ConnectionAction: Action {
    
    func reduce(_ state: inout ConnectionState) throws
    
}

struct ConnectionStartAction: ConnectionAction {
    
    func reduce(_ state: inout ConnectionState) throws {
        switch state {
        case .ready:
            state = .connecting
        case .disconnected:
            state = .reconnecting
        default:
            break
        }
    }
    
}

struct ConnectionSuccessAction: ConnectionAction {
    
    func reduce(_ state: inout ConnectionState) throws {
        switch state {
        case .connecting, .reconnecting:
            state = .connected
        default:
            break
        }
    }
    
}

struct ConnectionFailureAction: ConnectionAction {
    
    var error: Error
    
    func reduce(_ state: inout ConnectionState) throws {
        switch state {
        case .connecting, .reconnecting, .connected:
            state = .disconnected(error: error)
        default:
            break
        }
    }
    
}
