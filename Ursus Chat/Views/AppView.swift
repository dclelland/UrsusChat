//
//  AppView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import Ursus

struct AppView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        switch store.state {
        case .login(let state):
            return AnyView(
                LoginView(state: state, handler: loginHandler)
            )
        case .chat(let state):
            return AnyView(
                TabView {
                    ChatView(state: state)
                    SettingsView()
                }
            )
        }
    }
    
}

extension AppView {
    
    private func loginHandler(url: URL, code: Code) {
        
    }
    
}

struct AppView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppView()
    }
    
}
