//
//  SettingsView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: store[SessionLogoutAction()]) {
                        Text("Logout")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
        }
        .tabItem {
            Image(systemName: "gear")
            Text("Settings")
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView()
            .environmentObject(AppStore.preview)
    }
    
}
