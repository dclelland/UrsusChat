//
//  UnauthenticatedView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct UnauthenticatedView: View {
    
    let state: UnauthenticatedState
    
    var body: some View {
        NavigationView {
            LoginView(state: state.loginState)
        }
    }
    
}

struct UnauthenticatedView_Previews: PreviewProvider {
    
    static var previews: some View {
        UnauthenticatedView(state: UnauthenticatedState())
    }
    
}
