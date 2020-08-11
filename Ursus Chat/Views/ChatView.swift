//
//  ChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import KeyboardObserving
import NonEmpty

struct ChatViewModel {
    
    var rows: [ChatViewRowModel]
    
    init(chat: Chat) {
        self.rows = []
        
        if chat.mailbox.unloaded > 0 {
            self.rows.append(
                .loadingIndicator(loading: chat.loadingMessages)
            )
        }
        
        let envelopeRowModels = chat.pendingMessages.map { envelope in
            return ChatEnvelopesRowModel(envelope: envelope, state: .pending)
        } + chat.mailbox.envelopes.map { envelope in
            return ChatEnvelopesRowModel(envelope: envelope, state: .sent)
        }
        
        self.rows.append(
            contentsOf: envelopeRowModels.enumerated().reversed().reduce(into: [ChatViewRowModel]()) { result, element in
                let (index, envelopeRowModel) = element
                switch result.popLast() {
                case .some(.envelopes(let previousEnvelopeRowModel)) where previousEnvelopeRowModel.head.envelope.when.compare(toDate: envelopeRowModel.envelope.when, granularity: .day) != .orderedSame:
                    result.append(.envelopes(viewModel: previousEnvelopeRowModel))
                    result.append(.dateIndicator(date: envelopeRowModel.envelope.when))
                    result.append(.envelopes(viewModel: NonEmpty(envelopeRowModel)))
                case .some(.envelopes(let previousEnvelopeRowModel)) where previousEnvelopeRowModel.head.envelope.author == envelopeRowModel.envelope.author:
                    result.append(.envelopes(viewModel: previousEnvelopeRowModel + [envelopeRowModel]))
                case .some(let rowModel):
                    result.append(rowModel)
                    result.append(.envelopes(viewModel: NonEmpty(envelopeRowModel)))
                case .none:
                    result.append(.dateIndicator(date: envelopeRowModel.envelope.when))
                    result.append(.envelopes(viewModel: NonEmpty(envelopeRowModel)))
                }
                if chat.mailbox.unread > 0 && index == chat.mailbox.unread {
                    result.append(.readIndicator(unread: chat.mailbox.unread))
                }
            }
        )
    }
    
}

struct ChatView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State var message: String = ""
    
    @State var messageHeight: CGFloat = 0
    
    var messageTextFieldHeight: CGFloat {
        return min(max(messageHeight, 30.0), 70.0)
    }
    
    var path: String
    
    var chat: Chat {
        return store.state.subscription.chat(for: path)
    }
    
    var viewModel: ChatViewModel {
        return ChatViewModel(chat: chat)
    }
    
    #warning("TODO: Swap for LazyVStack when iOS 14 is ready; this will stop .onAppear from being called immediately")
    #warning("TODO: Send read call on read indicator appearance")
    
    var body: some View {
        VStack(spacing: 0.0) {
            List(viewModel.rows.reversed()) { row in
                ChatViewRow(viewModel: row)
                .animation(nil)
                .scaleEffect(x: 1.0, y: -1.0, anchor: .center)
                .onAppear {
                    if case .loadingIndicator(false) = row {
                        self.getMessages()
                    }
                }
                .onTapGesture {
                    if case .readIndicator = row {
                        self.sendRead()
                    }
                }
            }
            .animation(nil)
            .offset(x: 0.0, y: -1.0)
            .scaleEffect(x: 1.0, y: -1.0, anchor: .center)
            .listStyle(PlainListStyle())
            .introspectTableView { tableView in
                tableView.tableFooterView = UIView()
                tableView.separatorStyle = .none
                tableView.keyboardDismissMode = .onDrag
            }
            Divider()
                .edgesIgnoringSafeArea(.horizontal)
            HStack(alignment: .top) {
                ZStack(alignment: .topLeading) {
                    if message.isEmpty {
                        Text("Message...")
                            .foregroundColor(.secondary)
                    }
                    DynamicHeightTextField(text: $message, height: $messageHeight)
                }
                .frame(height: messageTextFieldHeight)
                Button(action: sendMessage) {
                    Text("Send")
                }
                .disabled(message.isEmpty)
            }
            .padding()
        }
        .navigationBarTitle(Text(chat.chatTitle), displayMode: .inline)
        .keyboardObserving()
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
        let unreadUnloaded = mailbox.unread - mailbox.envelopes.count
        let excessUnread: Bool = unreadUnloaded > maximumBacklogSize
        
        if (!excessUnread && unreadUnloaded + 20 > defaultBacklogSize) {
            getMessages(size: unreadUnloaded + 20)
        } else {
            getMessages(size: defaultBacklogSize)
        }
    }
    
    func getMessages(size: Int) {
        store.dispatch(AppThunk.getMessages(path: path, range: chat.mailbox.rangeOfNextPage(size: size)))
    }
    
}
