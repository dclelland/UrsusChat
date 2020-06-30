//
//  AppView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @State var authenticated: Bool = true
    
    var body: some View {
        if authenticated {
            return AnyView(
                TabView {
                    ChatsView()
                    SettingsView()
                }
            )
        } else {
            return AnyView(
                AuthenticationView()
            )
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppView()
    }
    
}
