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
        VStack(spacing: 0.0) {
            List(chat.mailbox.aggregatedEnvelopes.reversed(), id: \.head.uid) { envelopes in
                ChatRow(envelopes: envelopes)
            }
            .introspectTableView { tableView in
                tableView.tableFooterView = UIView()
                tableView.separatorStyle = .none
            }
            Divider()
            HStack {
                TextField("Message...", text: $message)
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationBarTitle(Text(chat.chatTitle), displayMode: .inline)
        .introspectViewController { viewController in
            viewController.hidesBottomBarWhenPushed = true
        }
    }
    
}

extension ChatView {
    
    func sendMessage() {
        
    }
    
}
