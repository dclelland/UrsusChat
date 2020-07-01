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
        Text("Chats")
//        List(state.inbox, id: \.key) { _ in
//            Text("Chats")
//        }
        .navigationBarTitle("All Chats")
    }
    
}

struct ChatListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListView(state: ChatState())
    }
    
}
