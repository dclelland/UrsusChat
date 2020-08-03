//
//  MetadataUpdate+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

extension Associations {
    
    var chat: AppAssociations {
        return self["chat", default: [:]]
    }
    
    var contacts: AppAssociations {
        return self["contacts", default: [:]]
    }
    
}

extension AppAssociations {
    
    func association(for path: Path) -> Association? {
        return self[path]
    }
    
}
