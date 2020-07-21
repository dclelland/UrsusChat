//
//  DirectMessageView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 21/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct DirectMessageView: View {
    
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
                Section {
                    Button(action: self.startDirectMessage) {
                        Text("Start Direct Message")
                    }
                }
            }
            .disabled(self.isLoading)
            .navigationBarTitle("Direct Message")
        }
    }
    
}

extension DirectMessageView {
    
    private func startDirectMessage() {
        
    }
    
}
