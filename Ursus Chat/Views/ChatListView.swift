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
        List(state.inbox.sorted(by: { $0.key > $1.key }), id: \.key) { state in
            NavigationLink(destination: ChatView(state: state)) {
                ChatListRow(state: state)
            }
        }
        .navigationBarTitle("All Chats")
    }
    
}

struct ChatListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListView(state: SubscriptionState())
    }
    
}
