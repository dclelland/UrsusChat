//
//  CGContext+Extensions.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation

extension CGContext {
    
    internal func draw(_ actions: (CGContext) -> Void) {
        saveGState()
        actions(self)
        restoreGState()
    }
    
}
