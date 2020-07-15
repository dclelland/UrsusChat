//
//  PatQ.swift
//  Alamofire
//
//  Created by Daniel Clelland on 27/06/20.
//

import Foundation
import BigInt

public struct PatQ: Aura {
    
    public var atom: BigUInt
    
    public var string: String {
        return PhoneticBaseParser.render(syllables: syllables, spacing: .shortSpacing)
    }

    public init(atom: BigUInt) {
        self.atom = atom
    }
    
    public init(string: String) throws {
        self.init(syllables: try PhoneticBaseParser.parse(string))
    }
    
}

extension PatQ {
    
    public init(syllables: [PhoneticBaseSyllable]) {
        let bytes = syllables.map(\.byte)
        let atom = BigUInt(Data(bytes))
        self.init(atom)
    }
    
    public var syllables: [PhoneticBaseSyllable] {
        let bytes = atom.serialize()
        let syllables: [PhoneticBaseSyllable] = bytes.reversed().enumerated().reduce([]) { result, element in
            let (index, byte) = element
            switch index.parity {
            case .even:
                return [.suffix(byte: byte)] + result
            case .odd:
                return [.prefix(byte: byte)] + result
            }
        }
        
        switch syllables.count {
        case 0:
            return [.suffix(byte: 0)]
        default:
            return syllables
        }
    }
    
}

extension PatQ: CustomStringConvertible {
    
    public var description: String {
        return string
    }
    
}

extension PatQ: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return ".~" + string
    }
    
}
