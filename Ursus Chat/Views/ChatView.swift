//
//  ChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var store: AppStore
    
    var path: String
    
    var body: some View {
        List(store.state.subscription.inbox.mailbox(for: path).envelopes.reversed(), id: \.uid) { envelope in
            ChatRow(envelope: envelope)
        }
        .navigationBarTitle(store.state.subscription.chat(for: path).chatTitle)
    }
    
}

struct ChatView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatView(path: "/~fipfes-fipfes/preview-chat")
            .environmentObject(AppStore.preview)
    }
    
}
