//
//  SettingsView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
            }
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
    }
    
}
