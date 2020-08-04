//
//  ModalView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 21/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ModalView<Label: View, Content: View>: View {
    
    #warning("TODO: Fix viewBuilder scope capturing; should calls in there be calls to self?")
    
    @Environment(\.presentationMode) var presentationMode
    
    var dismissLabel: () -> Label
    
    let viewBuilder: () -> Content
    
    var body: some View {
        NavigationView {
            viewBuilder()
            .navigationBarItems(
                trailing: Button(action: dismiss, label: dismissLabel)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}


extension ModalView {
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
}
