//
//  ChatListRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatListRow: View {
    
    struct ViewModel {
        
        var title: String
        var subtitle: String
        var message: String
        var date: String
        var unread: String?
        
    }
    
    @EnvironmentObject var store: AppStore
    
    var path: String
    
    var chat: Chat {
        return store.state.subscription.chat(for: path)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2.0) {
                Text(chat.chatTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(chat.groupTitle ?? "")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(chat.mailbox.envelopes.first?.letter.text ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8.0) {
                Text(chat.mailbox.envelopes.first?.when.formattedDate ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(String(chat.mailbox.unread))
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .padding(.horizontal, 4.0)
                    .frame(minWidth: 18.0, minHeight: 18.0)
                    .background(
                        RoundedRectangle(cornerRadius: 9.0, style: .continuous)
                            .fill(Color(UIColor.systemGray2))
                    )
                    .opacity(chat.mailbox.unread > 0 ? 1.0 : 0.0)
            }
        }
        .padding(.vertical, 4.0)
    }
    
}
