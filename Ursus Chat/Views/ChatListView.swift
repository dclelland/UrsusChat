//
//  ChatListView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import Ursus

struct ChatListView: View {
    
    @EnvironmentObject var store: AppStore
    
    var state: ChatState
    
    var body: some View {
        List(state.inbox.sorted(by: { $0.key > $1.key }), id: \.key) { (name, mailbox) in
            ChatListRow(name: name, mailbox: mailbox)
        }
        .navigationBarTitle("All Chats")
    }
    
}

struct ChatListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListView(state: ChatState())
    }
    
}
