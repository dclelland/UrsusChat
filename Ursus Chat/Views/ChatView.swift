//
//  ChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var store: AppStore
    
    var path: String
    
    var chat: Chat {
        return store.state.subscription.chat(for: path)
    }
    
    var body: some View {
        List(chat.mailbox.envelopes.reversed(), id: \.uid) { envelope in
            ChatRow(envelope: envelope)
        }
        .navigationBarTitle(chat.chatTitle)
    }
    
}
