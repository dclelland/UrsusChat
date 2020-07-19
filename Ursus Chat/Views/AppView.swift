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
        ErrorView(error: store.state.errors.first) {
            RootView()
        }
    }
    
}
