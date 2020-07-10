//
//  ChatUpdate+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftDate
import Ursus

extension SubscriptionState {
    
    func chat(for path: String) -> Chat {
        let chatAssociation = associations.chat.association(for: path)
        let contactsAssociation = chatAssociation.flatMap { associations.contacts.association(for: $0.groupPath) }
        
        return Chat(
            path: path,
            mailbox: inbox.mailbox(for: path),
            contacts: contactsAssociation.flatMap { contacts.contacts(for: $0.groupPath) } ?? [:],
            chatMetadata: chatAssociation?.metadata,
            contactsMetadata: contactsAssociation?.metadata
        )
    }
    
}

struct Chat {
    
    var path: String
    var mailbox: Mailbox
    var contacts: Contacts
    
    var chatMetadata: Metadata?
    var contactsMetadata: Metadata?
    
}

extension Chat {
    
    var chatTitle: String {
        return chatMetadata?.title ?? path
    }
    
    var groupTitle: String? {
        return contactsMetadata?.title ?? chatMetadata?.creator.debugDescription
    }
    
    func nickname(for ship: Ship) -> String {
        return contacts.contact(for: ship.description)?.nickname ?? ship.debugDescription
    }
    
}

extension Inbox {
    
    func mailbox(for path: String) -> Mailbox {
        return self[path] ?? Mailbox(config: MailboxConfig(length: 0, read: 0), envelopes: [])
    }
    
}

extension Mailbox {
    
    var when: Date {
        return envelopes.first?.when ?? Date.distantPast
    }
    
    var unread: Int {
        return config.length - config.read
    }
    
}

extension Envelope {
    
    var formattedDate: String {
        if when.compare(.isToday) {
            return when.toString(.time(.short))
        } else if when.compare(toDate: Date() - 7.days, granularity: .day) != .orderedAscending {
            return when.weekdayName(.default)
        } else {
            return when.toString(.date(.short))
        }
    }
    
}

extension Letter {
    
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
