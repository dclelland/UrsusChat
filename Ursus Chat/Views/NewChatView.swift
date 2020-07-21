//
//  NewChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 21/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import KeyboardObserving

struct NewChatView: View {
    
    @State var name: String = ""
    
    @State var description: String = ""
    
    var isLoading: Bool = false
    
    var body: some View {
        ModalView(dismissLabel: { Text("Cancel") }) {
            Form {
                Section(header: Text("Name")) {
                    TextField("Secret chat", text: self.$name)
                }
                Section(header: Text("Description"), footer: Text("(Optional)")) {
                    TextField("The coolest chat", text: self.$description)
                }
                Section {
                    Button(action: self.startChat) {
                        Text("Start Chat")
                    }
                }
            }
            .disabled(self.isLoading)
            .navigationBarTitle("New Chat")
            .keyboardObserving()
        }
    }
    
}

extension NewChatView {
    
    private func startChat() {
        
    }
    
}
