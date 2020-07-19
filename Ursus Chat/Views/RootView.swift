//
//  RootView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        switch store.state.session {
        case .unauthenticated:
            return AnyView(
                LoginView(isAuthenticating: false)
            )
        case .authenticating:
            return AnyView(
                LoginView(isAuthenticating: true)
            )
        case .authenticated(_, let ship):
            return AnyView(
                ChatListView(ship: ship)
            )
        }
    }
    
}
