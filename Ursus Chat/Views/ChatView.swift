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
    
    @State var message: String = ""
    
    var path: String
    
    var chat: Chat {
        return store.state.subscription.chat(for: path)
    }
    
    var body: some View {
        VStack {
            List(chat.mailbox.envelopes.reversed(), id: \.uid) { envelope in
                ChatRow(envelope: envelope)
            }
//            HStack {
//                TextField("Message...", text: $message)
//                    .frame(minHeight: CGFloat(30))
//                Button(action: sendMessage) {
//                    Text("Send")
//                }
//            }
//            .frame(minHeight: CGFloat(50))
//            .padding()
        }
        .navigationBarTitle(chat.chatTitle)
    }
    
}

extension ChatView {
    
    func sendMessage() {
        
    }
    
}
