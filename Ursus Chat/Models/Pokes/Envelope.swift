//
//  Envelope.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 16/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

struct Envelope: Encodable {
    
    var uid: String = UUID().base32String
    var number: Int
    var author: String
    var when: Int = Int(Date().timeIntervalSince1970 * 1000)
    var letter: [String: String]
    
}
