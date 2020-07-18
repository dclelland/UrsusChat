//
//  AckRequest.swift
//  Ursus
//
//  Created by Daniel Clelland on 7/06/20.
//

import Foundation

internal struct AckRequest: Encodable {
    
    var action: String = "ack"
    var eventID: Int
    
}
