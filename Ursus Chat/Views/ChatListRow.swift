//
//  ChatListRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatListRow: View {
    
    @EnvironmentObject var store: AppStore
    
    var state: (name: String, mailbox: Mailbox)
    
    var body: some View {
        Text(state.name)
    }
    
}

struct ChatListRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListRow(
            state: (
                name: "name",
                mailbox: Mailbox(
                    config: MailboxConfig(
                        length: 0,
                        read: 0
                    ),
                    envelopes: [
                        Envelope(
                            uid: "0",
                            number: 0,
                            author: "author",
                            when: Date(),
                            letter: .text("Hello")
                        )
                    ]
                )
            )
        ).previewLayout(.sizeThatFits)
    }
    
}
