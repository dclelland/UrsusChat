//
//  ContactUpdate+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

extension Rolodex {
    
    func contacts(for path: Path) -> Contacts {
        return self[path, default: [:]]
    }
    
}

extension Contacts {
    
    func contact(for ship: Ship) -> Contact? {
        return self[ship]
    }
    
}
