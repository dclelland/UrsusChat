//
//  JoinChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 21/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct JoinChatView: View {
    
    @State var name: String = ""
    
    var isLoading: Bool = false
    
    var body: some View {
        ModalView(dismissLabel: { Text("Cancel") }) {
            Form {
                Section(header: Text("Chat name"), footer: Text("Enter a ~ship/chat-name or ~/~ship/chat-name. Chat names use lowercase, hyphens, and slashes.")) {
                    TextField("~zod/chatroom", text: self.$name)
                        .keyboardType(.asciiCapable)
                        .autocapitalization(.none)
                }
                Section {
                    Button(action: self.joinChat) {
                        Text("Join Chat")
                    }
                }
            }
            .disabled(self.isLoading)
            .navigationBarTitle("Join Chat")
        }
    }
    
}

extension JoinChatView {
    
    func joinChat() {
        
    }
    
}

