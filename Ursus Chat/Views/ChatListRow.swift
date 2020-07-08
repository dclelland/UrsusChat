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
        var author: String
        var date: String
        var unread: String?
        
    }
    
    @EnvironmentObject var store: AppStore
    
    var path: String
    
    var model: ViewModel {
        let mailbox = store.state.subscription.inbox.mailbox(for: path)
        let association = store.state.subscription.associations.chat.association(for: path)
        let groupAssociation = store.state.subscription.associations.contacts.association(for: association?.groupPath ?? path)
        let contact = store.state.subscription.contacts.contacts(for: association?.groupPath ?? path).contact(for: mailbox?.envelopes.last?.author.description ?? "")
        
        let dateFormatter = RelativeDateTimeFormatter()
        
        let date = mailbox?.envelopes.last?.when ?? Date()
        
        return ViewModel(
            title: (association?.metadata.title ?? path) + " (\(groupAssociation?.metadata.title ?? ""))",
            subtitle: contact?.nickname ?? mailbox?.envelopes.last?.author.debugDescription ?? "",
            author: mailbox?.envelopes.last?.letter.text ?? "",
            date: dateFormatter.localizedString(for: date, relativeTo: Date()),
            unread: mailbox?.unread.description
        )
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(model.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(model.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(model.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(model.unread ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
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
