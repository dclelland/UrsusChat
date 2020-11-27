//
//  GroupUpdate+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 31/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock
import UrsusAPI

extension Resource {
    
    var path: Path {
        return "/ship/\(ship.description)/\(name)"
    }
    
}
