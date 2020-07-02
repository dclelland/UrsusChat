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
    
    private var subscription: SubscriptionState {
        return store.state.subscription
    }
    
    var body: some View {
        NavigationView {
            List(subscription.inbox.sorted(by: \.key), id: \.key) { state in
                NavigationLink(destination: ChatView(state: state)) {
                    ChatListRow(state: state)
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

struct ChatListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListView().environmentObject(AppStore.preview)
    }
    
}
