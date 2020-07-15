//
//  PatUV.swift
//  Alamofire
//
//  Created by Daniel Clelland on 27/06/20.
//

import Foundation
import BigInt

public struct PatUV: Aura {
    
    public var atom: BigUInt
    
    public var string: String {
        return "0v" + String(self, radix: 32, chunk: 5)
    }

    internal init(atom: BigUInt) {
        self.atom = atom
    }
    
    init(string: String) throws {
        fatalError("PatUV.init(string:) is not implemented yet")
    }
    
}

extension PatUV: CustomStringConvertible {
    
    public var description: String {
        return string
    }
    
}

extension PatUV: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return string
    }
    
}
