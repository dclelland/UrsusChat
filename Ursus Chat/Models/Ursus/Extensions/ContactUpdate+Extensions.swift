//
//  ContactUpdate+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

extension Rolodex {
    
    func contacts(for path: String) -> Contacts {
        return self[path] ?? [:]
    }
    
}

extension Contacts {
    
    func contact(for ship: String) -> Contact? {
        return self[ship]
    }
    
}
