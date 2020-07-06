//
//  SessionState.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import Ursus

struct SessionState: StateType {
    
    struct Credentials {
        
        var url: String = ""
        var code: String = ""
        
    }
    
    var credentials: Credentials = Credentials()
    var client: Ursus? = nil
    
}
