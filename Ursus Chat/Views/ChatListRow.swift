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
        let contact = store.state.subscription.contacts.contacts(for: association?.groupPath ?? path).contact(for: mailbox?.envelopes.last?.author.description ?? "")
        
        return ViewModel(
            title: association?.metadata.title ?? path,
            subtitle: contact?.nickname ?? mailbox?.envelopes.last?.author.debugDescription ?? "",
            author: mailbox?.envelopes.last?.letter.text ?? "",
            date: DateFormatter.localizedString(from: mailbox?.envelopes.last?.when ?? Date(), dateStyle: .short, timeStyle: .none),
            unread: (mailbox!.config.length - mailbox!.config.read).description
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

private extension Inbox {
    
    func mailbox(for path: String) -> Mailbox? {
        return self[path]
    }
    
}

private extension Letter {
    
    var text: String {
        switch self {
        case .text(let text):
            return text
        case .url(let url):
            return url
        case .code(let code):
            return code.expression
        case .me(let narrative):
            return narrative
        }
    }
    
}

private extension Rolodex {
    
    func contacts(for path: String) -> Contacts {
        return self[path] ?? [:]
    }
    
}

private extension Contacts {
    
    func contact(for ship: String) -> Contact? {
        return self[ship]
    }
    
}

private extension Associations {
    
    var chat: AppAssociations {
        return self["chat"] ?? [:]
    }
    
}

private extension AppAssociations {
    
    func association(for path: String) -> Association? {
        return self[path]
    }
    
}
