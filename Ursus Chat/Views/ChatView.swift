//
//  ChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI
import KeyboardObserving

struct ChatView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State var message: String = ""
    
    var path: String
    
    var chat: Chat {
        return store.state.subscription.chat(for: path)
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            List(chat.mailbox.authorAggregatedEnvelopes.reversed(), id: \.head.uid) { envelopes in
                ChatRow(envelopes: envelopes)
                .scaleEffect(x: 1.0, y: -1.0, anchor: .center)
            }
            .offset(x: 0.0, y: -1.0)
            .scaleEffect(x: 1.0, y: -1.0, anchor: .center)
            .listStyle(PlainListStyle())
            .introspectTableView { tableView in
                tableView.tableFooterView = UIView()
                tableView.separatorStyle = .none
                tableView.keyboardDismissMode = .onDrag
            }
            Divider()
            HStack {
                TextField("Message...", text: $message)
                Button(action: sendMessage) {
                    Text("Send")
                }
                .disabled(message.isEmpty)
            }
            .padding()
        }
        .navigationBarTitle(Text(chat.chatTitle), displayMode: .inline)
        .keyboardObserving()
        .onAppear(perform: sendRead)
        .onAppear(perform: getMessages)
    }
    
}

extension ChatView {
    
    func sendRead() {
        store.dispatch(AppThunk.sendRead(path: path))
    }
    
    func sendMessage() {
        store.dispatch(AppThunk.sendMessage(path: path, letter: .text(message)))
        message = ""
    }
    
    func getMessages() {
        let defaultBacklogSize = 300
        let maximumBacklogSize = 1000
        
        let mailbox = chat.mailbox
        let unread = mailbox.config.length - mailbox.config.read
        let unreadUnloaded = unread - mailbox.envelopes.count
        let excessUnread: Bool = unreadUnloaded > maximumBacklogSize
        
        if (!excessUnread && unreadUnloaded + 20 > defaultBacklogSize) {
            getMessages(size: unreadUnloaded + 20)
        } else {
            getMessages(size: defaultBacklogSize)
        }
    }
    
    func getMessages(size: Int) {
        let mailbox = chat.mailbox
        if mailbox.hasNextPage {
            store.dispatch(AppThunk.getMessages(path: path, range: mailbox.rangeOfNextPage(size: size)))
        }
    }
    
}
