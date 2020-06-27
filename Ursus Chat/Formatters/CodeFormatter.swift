//
//  PatPFormatter.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 27/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Ursus

class CodeFormatter: Formatter {
    
    override func string(for object: Any?) -> String? {
        return (object as? Code)?.description
    }
    
    override func getObjectValue(_ object: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        object?.pointee = try? Code(string: string) as AnyObject
        return true
    }
    
}
