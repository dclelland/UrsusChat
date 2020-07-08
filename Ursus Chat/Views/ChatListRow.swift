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
    
    struct ViewModel {
        
        var title: String
        var subtitle: String
        var message: String
        var date: String
        var unread: String?
        
    }
    
    @EnvironmentObject var store: AppStore
    
    var path: String
    
    var model: ViewModel {
        let chat = store.state.subscription.chat(for: path)
        let envelope = chat.mailbox.envelopes.first
        
        let dateFormatter = RelativeDateTimeFormatter()
        
        let date = envelope?.when ?? Date()
        
        return ViewModel(
            title: chat.chatTitle,
            subtitle: chat.groupTitle ?? "",
            message: envelope?.letter.text ?? "",
            date: dateFormatter.localizedString(for: date, relativeTo: Date()),
            unread: chat.mailbox.unread > 0 ? chat.mailbox.unread.description : nil
        )
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2.0) {
                Text(model.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(model.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(model.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8.0) {
                Text(model.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(model.unread ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .padding(.horizontal, 4.0)
                    .frame(minWidth: 18.0, minHeight: 18.0)
                    .background(
                        RoundedRectangle(cornerRadius: 9.0, style: .continuous)
                            .fill(Color(UIColor.systemGray2))
                    )
                    .opacity(model.unread == nil ? 0.0 : 1.0)
            }
        }
    }
    
}

struct ChatListRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListRow(path: "/~fipfes-fipfes/preview-chat")
            .environmentObject(AppStore.preview)
            .previewLayout(.sizeThatFits)
    }
    
}
