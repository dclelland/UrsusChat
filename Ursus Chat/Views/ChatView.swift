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
    
    var state: (name: String, mailbox: ChatStoreApp.Mailbox)
    
    var body: some View {
        List(state.mailbox.envelopes.reversed(), id: \.uid) { envelope in
            ChatRow(state: envelope)
        }
        .navigationBarTitle(state.name)
    }
    
}

struct ChatView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatView(
            state: (
                name: "name",
                mailbox: ChatStoreApp.Mailbox(
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
            )
        )
    }
    
}
