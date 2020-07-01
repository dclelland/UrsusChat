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
        switch store.state {
        case .unauthenticatedState(let state):
            return AnyView(UnauthenticatedView(state: state))
        case .authenticatedState(let state):
            return AnyView(AuthenticatedView(state: state))
        }
    }
    
}

struct AppView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppView()
    }
    
}
