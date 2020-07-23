//
//  NewDirectMessageView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 23/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import KeyboardObserving

struct NewDirectMessageView: View {
    
    @State var ship: String = ""
    
    var isLoading: Bool = false
    
    var body: some View {
        ModalView(dismissLabel: { Text("Cancel") }) {
            Form {
                Section(header: Text("Ship name")) {
                    TextField("~sampel-palnet", text: self.$ship)
                        .keyboardType(.asciiCapable)
                        .autocapitalization(.none)
                }
            }
            .disabled(self.isLoading)
            .navigationBarTitle("New Direct Message")
            .keyboardObserving()
        }
    }
    
}

extension NewDirectMessageView {
    
    private func startDirectMessage() {
        
    }
    
}
