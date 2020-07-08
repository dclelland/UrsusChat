//
//  MetadataUpdate+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

extension Associations {
    
    var chat: AppAssociations {
        return self["chat"] ?? [:]
    }
    
    var contacts: AppAssociations {
        return self["contacts"] ?? [:]
    }
    
}

extension AppAssociations {
    
    func association(for path: String) -> Association? {
        return self[path]
    }
    
}
