//
//  ChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State var state: ChatState
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Chats")
            }
            .navigationBarTitle("All Chats")
        }
        .tabItem {
            Image(systemName: "text.bubble")
            Text("Chats")
        }
    }
    
}

struct ChatsView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatView(state: ChatState())
    }
    
}
