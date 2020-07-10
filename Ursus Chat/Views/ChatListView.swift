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
    
    var body: some View {
        NavigationView {
            List(store.state.subscription.inbox.sorted(by: \.value.when).reversed(), id: \.key) { (path, mailbox) in
                NavigationLink(destination: ChatView(path: path)) {
                    ChatListRow(path: path)
                }
            }
            .navigationBarTitle("Chats")
        }
        .tabItem {
            Image(systemName: "text.bubble")
            Text("Chats")
        }
    }
    
}
