//
//  PatUV.swift
//  Alamofire
//
//  Created by Daniel Clelland on 27/06/20.
//

import Foundation
import BigInt

public struct PatUV: Aura {
    
    internal var atom: BigUInt

    internal init(_ atom: BigUInt) {
        self.atom = atom
    }
    
}

extension PatUV: CustomStringConvertible {
    
    public var description: String {
        return "0v" + String(self, radix: 32, chunk: 5)
    }
    
}

extension PatUV: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return description
    }
    
}

extension PatUV: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
    
}
