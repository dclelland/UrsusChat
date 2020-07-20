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

    public init(atom: BigUInt) {
        self.atom = atom
    }
    
    public init(string: String) {
        fatalError("PatUV.init(string:) is not implemented yet")
    }
    
}
