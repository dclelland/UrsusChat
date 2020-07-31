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
            .onAppear(perform: getMessages)
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
        store.dispatch(AppThunk.getMessages(path: path, start: 0, end: 20))
        
//        const DEFAULT_BACKLOG_SIZE = 300;
//        const MAX_BACKLOG_SIZE = 1000;
        
//        receivedNewChat() {
//          const { props } = this;
//          this.hasAskedForMessages = false;
//
//          this.unreadMarker = null;
//          this.scrolledToMarker = false;
//
//          this.setState({ read: props.read });
//
//          const unread = props.length - props.read;
//          const unreadUnloaded = unread - props.envelopes.length;
//          const excessUnread = unreadUnloaded > MAX_BACKLOG_SIZE;
//
//          if (!excessUnread && unreadUnloaded + 20 > DEFAULT_BACKLOG_SIZE) {
//            this.askForMessages(unreadUnloaded + 20);
//          } else {
//            this.askForMessages(DEFAULT_BACKLOG_SIZE);
//          }
//
//          if (excessUnread || props.read === props.length) {
//            this.scrolledToMarker = true;
//            this.setState(
//              {
//                scrollLocked: false,
//              },
//              () => {
//                this.scrollToBottom();
//              }
//            );
//          } else {
//            this.setState({ scrollLocked: true, numPages: Math.ceil(unread / 100) });
//          }
//        }
        
//        askForMessages(size) {
//          const { props, state } = this;
//
//          if (
//            props.envelopes.length >= props.length ||
//            this.hasAskedForMessages ||
//            props.length <= 0
//          ) {
//            return;
//          }
//
//          const start =
//            props.length - props.envelopes[props.envelopes.length - 1].number;
//          if (start > 0) {
//            const end = start + size < props.length ? start + size : props.length;
//            this.hasAskedForMessages = true;
//            props.api.chat.fetchMessages(start + 1, end, props.station);
//          }
//        }
        
//        fetchMessages(start: number, end: number, path: Path) {
//          fetch(`/chat-view/paginate/${start}/${end}${path}`)
//            .then(response => response.json())
//            .then((json) => {
//              this.store.handleEvent({
//                data: json
//              });
//            });
//        }
    }
    
}
