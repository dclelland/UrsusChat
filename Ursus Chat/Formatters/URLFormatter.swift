//
//  URLFormatter.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

class URLFormatter: Formatter {
    
    override func string(for object: Any?) -> String? {
        return (object as? URL)?.path
    }
    
    override func getObjectValue(_ object: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        object?.pointee = URL(string: string) as AnyObject
        return true
    }
    
}
