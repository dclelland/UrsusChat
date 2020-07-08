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
    
    var mailbox: Mailbox
    
    var metadata: Metadata? = nil
    
    var body: some View {
        List(mailbox.envelopes.reversed(), id: \.uid) { envelope in
            ChatRow(state: envelope)
        }
        .navigationBarTitle(metadata?.title ?? "")
    }
    
}

struct ChatView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatView(
            mailbox: Mailbox(
                config: MailboxConfig(
                    length: 0,
                    read: 0
                ),
                envelopes: [
                    Envelope(
                        uid: "0",
                        number: 0,
                        author: "Author",
                        when: Date(),
                        letter: .text("Text")
                    )
                ]
            ),
            metadata: Metadata(
                title: "Title",
                description: "Description",
                color: "0x0",
                dateCreated: "~2020.1.1..00.00.00..0000",
                creator: "~zod"
            )
        )
    }
    
}
