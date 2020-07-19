//
//  ErrorView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ErrorView<Content: View>: View {
    
    @EnvironmentObject var store: AppStore
    
    var error: Error?
    
    let viewBuilder: () -> Content
    
    var body: some View {
        viewBuilder()
            .alert(isPresented: .constant(error != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(error?.localizedDescription ?? ""),
                dismissButton: .cancel(Text("OK"), action: store[AppDismissErrorAction()])
            )
        }
    }
    
}
