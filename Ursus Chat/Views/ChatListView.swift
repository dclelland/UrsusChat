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
            List(subscription.inbox.sorted(by: \.value.when).reversed(), id: \.key) { element in
                NavigationLink(destination: ChatView(path: element.key)) {
                    ChatListRow(path: element.key)
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

private extension Mailbox {
    
    var when: Date {
        return envelopes.last?.when ?? Date.distantPast
    }
    
}
