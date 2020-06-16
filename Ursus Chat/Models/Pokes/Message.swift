//
//  Message.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 16/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

struct Message: Encodable {
    
    var path: String
    var envelope: Envelope
    
}
