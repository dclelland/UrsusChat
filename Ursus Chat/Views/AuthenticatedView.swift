//
//  AuthenticatedView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct AuthenticatedView: View {
    
    let state: AuthenticatedState
    
    var body: some View {
        TabView {
            NavigationView {
                ChatListView(state: state.chatState)
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
    }
    
}

struct AuthenticatedView_Previews: PreviewProvider {
    
    static var previews: some View {
        AuthenticatedView(state: AuthenticatedState())
    }
    
}
