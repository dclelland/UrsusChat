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
        case .unauthenticated(let credentials):
            return AnyView(
                NavigationView {
                    LoginView(state: credentials)
                }
            )
        case .authenticated:
            return AnyView(
                TabView {
                    NavigationView {
                        ChatListView(state: store.state.subscription)
                    }
                    .tabItem {
                        Image(systemName: "text.bubble")
                        Text("Chats")
                    }
                    NavigationView {
                        SettingsView()
                    }
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
            )
        }
    }
    
}

struct AppView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppView()
    }
    
}
