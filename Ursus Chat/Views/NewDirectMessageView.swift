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
    
    @State var name: String = ""
    
    @State var description: String = ""
    
    @State var ships: String = ""
    
    var isLoading: Bool = false
    
    var body: some View {
        ModalView(dismissLabel: { Text("Cancel") }) {
            Form {
                Section(header: Text("Name (Optional)")) {
                    TextField("The Passage", text: self.$name)
                }
                Section(header: Text("Description (Optional)")) {
                    TextField("The most beautiful direct message", text: self.$description)
                }
                Section(header: Text("Select Ships"), footer: Text("Selected ships will be invited to the direct message")) {
                    TextField("Search for ships", text: self.$ships)
                        .keyboardType(.asciiCapable)
                        .autocapitalization(.none)
                }
                Section {
                    Button(action: self.createNewDirectMessage) {
                        Text("Create New Direct Message")
                    }
                }
            }
            .disabled(self.isLoading)
            .navigationBarTitle("New Direct Message")
            .keyboardObserving()
        }
    }
    
}

extension NewDirectMessageView {
    
    private func createNewDirectMessage() {
        
    }
    
}
