//
//  NewGroupChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 23/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import KeyboardObserving

struct NewGroupChatView: View {
    
    @State var name: String = ""
    
    @State var description: String = ""
    
    @State var group: String = ""
    
    var isLoading: Bool = false
    
    var body: some View {
        ModalView(dismissLabel: { Text("Cancel") }) {
            Form {
                Section(header: Text("Name")) {
                    TextField("Secret chat", text: self.$name)
                }
                Section(header: Text("Description (Optional)")) {
                    TextField("The coolest chat", text: self.$description)
                }
                Section(header: Text("Select Group"), footer: Text("Chat will be added to selected group")) {
                    TextField("Search for existing groups", text: self.$group)
                        .keyboardType(.asciiCapable)
                        .autocapitalization(.none)
                }
                Section(footer: Text("Disabled for now").foregroundColor(.red)) {
                    Button(action: self.startNewGroupChat) {
                        Text("Create New Group Chat")
                    }
                    .disabled(true)
                }
            }
            .disabled(self.isLoading)
            .navigationBarTitle("New Group Chat")
            .keyboardObserving()
        }
    }
    
}

extension NewGroupChatView {
    
    private func startNewGroupChat() {
        
    }
    
}

