//
//  AppAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

protocol AppAction: Action {
    
    func reduce(_ state: inout AppState) throws
    
}

struct AppLaunchAction: AppAction {
    
    func reduce(_ state: inout AppState) throws {
        state.session.credentials = SessionState.Credentials(
            url: "http://192.168.1.75:8080",
            code: "lacnyd-morped-pilbel-pocnep"
        )
    }
    
}

struct AppTerminateAction: AppAction {
    
    func reduce(_ state: inout AppState) throws {
        state.session.client = nil
    }
    
}

struct AppErrorAction: AppAction {
    
    var error: Error
    
    func reduce(_ state: inout AppState) throws {
        state.errors.append(error)
    }
    
}

struct AppDismissErrorAction: AppAction {
    
    func reduce(_ state: inout AppState) throws {
        state.errors.removeLast()
    }
    
}
