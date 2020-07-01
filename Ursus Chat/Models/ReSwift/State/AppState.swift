//
//  AppState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

enum AppState: StateType {
    
    case unauthenticatedState(UnauthenticatedState)
    case authenticatedState(AuthenticatedState)
    
}
