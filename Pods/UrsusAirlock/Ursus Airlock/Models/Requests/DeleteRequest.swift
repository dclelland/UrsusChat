//
//  DeleteRequest.swift
//  Ursus
//
//  Created by Daniel Clelland on 7/06/20.
//

import Foundation

internal struct DeleteRequest: Encodable {
    
    var action: String = "delete"
    
    enum CodingKeys: String, CodingKey {
        
        case action
        
    }
    
}
