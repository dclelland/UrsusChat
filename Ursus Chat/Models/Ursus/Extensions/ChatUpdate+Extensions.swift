//
//  ChatUpdate+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

extension Inbox {
    
    func mailbox(for path: String) -> Mailbox? {
        return self[path]
    }
    
}

extension Mailbox {
    
    var when: Date {
        return envelopes.last?.when ?? Date.distantPast
    }
    
    var unread: Int {
        return config.length - config.read
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
