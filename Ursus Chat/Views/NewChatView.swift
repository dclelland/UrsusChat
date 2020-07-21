//
//  NewChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 21/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct NewChatView: View {
    
    var body: some View {
        ModalView(dismissLabel: { Text("Cancel") }) {
            EmptyView()
            .navigationBarTitle("New Chat")
        }
    }
    
}
