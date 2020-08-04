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
import NonEmpty

extension Mailbox {
    
//    var dateAggregatedEnvelopes: [NonEmpty<[Envelope]>] {
//        return envelopes.reduce(into: []) { result, envelope in
//            if let last = result.popLast() {
//                if last.head.when.compare(toDate: envelope.when, granularity: .day) == .orderedSame {
//                    result.append(last + [envelope])
//                } else {
//                    result.append(last)
//                    result.append(NonEmpty(envelope))
//                }
//            } else {
//                result.append(NonEmpty(envelope))
//            }
//        }
//    }
    
}

struct ChatViewModel {
    
    var rows: [ChatViewRowModel]
    
    init(chat: Chat) {
        #warning("TODO: Add date indicator")
        #warning("TODO: Add read indicator")
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
            contentsOf: envelopeRowModels.reversed().reduce(into: [ChatViewRowModel]()) { result, envelopeRowModel in
                switch result.popLast() {
                case .some(.envelopes(let previousEnvelopeRowModel)) where previousEnvelopeRowModel.head.envelope.author == envelopeRowModel.envelope.author:
                    result.append(.envelopes(viewModel: previousEnvelopeRowModel + [envelopeRowModel]))
                case .some(let rowModel):
                    result.append(rowModel)
                    result.append(.envelopes(viewModel: NonEmpty(envelopeRowModel)))
                case .none:
                    result.append(.envelopes(viewModel: NonEmpty(envelopeRowModel)))
                }
            }
        )
    }
    
}

struct ChatView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State var message: String = ""
    
    var path: String
    
    var chat: Chat {
        return store.state.subscription.chat(for: path)
    }
    
    var viewModel: ChatViewModel {
        return ChatViewModel(chat: chat)
    }
    
    #warning("TODO: Swap for LazyVStack when iOS 14 is ready; this will stop .onAppear from being called immediately")
    
    var body: some View {
        VStack(spacing: 0.0) {
            List(viewModel.rows.reversed()) { row in
                ChatViewRow(viewModel: row)
                .scaleEffect(x: 1.0, y: -1.0, anchor: .center)
                .onAppear {
                    switch row {
                    case .loadingIndicator(false):
                        self.getMessages()
                    case .readIndicator:
                        self.sendRead()
                    default:
                        break
                    }
                }
            }
            .offset(x: 0.0, y: -1.0)
            .scaleEffect(x: 1.0, y: -1.0, anchor: .center)
            .listStyle(PlainListStyle())
            .animation(nil)
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
        .onAppear(perform: sendRead)
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
