//
//  HomeView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        TabView {
            ChatsView()
            SettingsView()
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
    
}
