//
//  ChatUpdate+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import NonEmpty
import SwiftDate
import UrsusAirlock

extension SubscriptionState {
    
    func chat(for path: Path) -> Chat {
        let chatAssociation = associations.chat.association(for: path)
        let contactsAssociation = chatAssociation.flatMap { associations.contacts.association(for: $0.groupPath) }
        
        return Chat(
            path: path,
            mailbox: inbox.mailbox(for: path),
            contacts: contactsAssociation.flatMap { contacts.contacts(for: $0.groupPath) } ?? [:],
            chatMetadata: chatAssociation?.metadata,
            contactsMetadata: contactsAssociation?.metadata,
            pendingMessages: pendingMessages[path, default: []],
            loadingMessages: loadingMessages[path, default: false]
        )
    }
    
}

struct Chat {
    
    var path: Path
    var mailbox: Mailbox
    var contacts: Contacts
    
    var chatMetadata: Metadata?
    var contactsMetadata: Metadata?
    
    var pendingMessages: [Envelope]
    var loadingMessages: Bool
    
}

extension Chat {
    
    var chatTitle: String {
        return chatMetadata?.title ?? path
    }
    
    var groupTitle: String? {
        return contactsMetadata?.title ?? chatMetadata?.creator.description
    }
    
    func nickname(for ship: Ship) -> String {
        return contacts.contact(for: ship)?.nickname ?? ship.description
    }
    
}

extension Inbox {
    
    func mailbox(for path: Path) -> Mailbox {
        return self[path, default: Mailbox(config: MailboxConfig(length: 0, read: 0), envelopes: [])]
    }
    
}

extension Mailbox {
    
    var when: Date {
        return envelopes.first?.when ?? Date.distantPast
    }
    
    var unread: Int {
        return config.length - config.read
    }
    
    var unloaded: Int {
        return config.length - envelopes.count
    }
    
    func rangeOfNextPage(size: Int) -> ClosedRange<Int> {
        let start = config.length - (envelopes.last?.number ?? 0)
        let end = min(start + size, config.length)
        return (start + 1)...end
    }
    
}

extension Envelope: Hashable {
    
    static func == (lhs: Envelope, rhs: Envelope) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
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
            return ([code.expression] + code.output.joined()).joined(separator: " ")
        case .me(let narrative):
            return narrative
        }
    }
    
}

extension Date {
    
    var formattedDateWithToday: String {
        if compare(.isToday) {
            return "Today"
        } else if compare(toDate: Date() - 7.days, granularity: .day) != .orderedAscending {
            return weekdayName(.default)
        } else {
            return toString(.date(.short))
        }
    }
    
    var formattedDate: String {
        if compare(.isToday) {
            return toString(.time(.short))
        } else if compare(toDate: Date() - 7.days, granularity: .day) != .orderedAscending {
            return weekdayName(.default)
        } else {
            return toString(.date(.short))
        }
    }
    
    var formattedTime: String {
        return toString(.time(.short))
    }
    
}
