//
//  ChatListView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatListView: View {
    
    @EnvironmentObject var store: AppStore
    
    var state: SubscriptionState
    
    var body: some View {
        List(state.inbox.sorted(by: \.key), id: \.key) { state in
            NavigationLink(destination: ChatView(state: state)) {
                ChatListRow(state: state)
            }
        }
        .navigationBarTitle("All Chats")
    }
    
}

struct ChatListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListView(
            state: SubscriptionState(
                inbox: [
                    "key": ChatStoreApp.Mailbox(
                        config: ChatStoreApp.Config(
                            length: 0,
                            read: 0
                        ),
                        envelopes: [
                            ChatStoreApp.Envelope(
                                uid: "0",
                                number: 0,
                                author: "author",
                                when: Date(),
                                letter: .text("Hello")
                            )
                        ]
                    )
                ]
            )
        )
    }
    
}
