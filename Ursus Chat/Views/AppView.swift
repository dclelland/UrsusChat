//
//  AppView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
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
        case .authenticated:
            return AnyView(
                ChatListView()
            )
        }
    }
    
}
