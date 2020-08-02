//
//  PatP.swift
//  Alamofire
//
//  Created by Daniel Clelland on 27/06/20.
//

import Foundation
import BigInt

public struct PatP: Aura {
    
    public var atom: BigUInt
    
    public var string: String {
        return "~" + PhoneticBaseParser.render(syllables: syllables, spacing: .long())
    }
    
    public var abbreviatedString: String {
        switch title {
        case .galaxy, .star, .planet:
            return "~" + PhoneticBaseParser.render(syllables: syllables, spacing: .long())
        case .moon:
            return "~" + PhoneticBaseParser.render(syllables: syllables.prefix(2) + syllables.suffix(2), spacing: .long(separator: "^"))
        case .comet:
            return "~" + PhoneticBaseParser.render(syllables: syllables.prefix(2) + syllables.suffix(2), spacing: .long(separator: "_"))
        }
    }

    public init(atom: BigUInt) {
        self.atom = atom
    }
    
    public init(string: String) throws {
        self.init(syllables: try PhoneticBaseParser.parse(string))
    }
    
}

extension PatP {
    
    public struct Prefixless: Aura {
        
        public var atom: BigUInt
        
        public var string: String {
            return String(PatP(self).string.dropFirst(1))
        }

        public init(atom: BigUInt) {
            self.atom = atom
        }
        
        public init(string: String) throws {
            try self.init(PatP(string: string))
        }
        
    }
    
}

extension PatP {
    
    public init(syllables: [PhoneticBaseSyllable]) {
        let bytes = syllables.map(\.byte)
        let deobfuscatedAtom = PhoneticBaseObfuscator.deobfuscate(BigUInt(Data(bytes)))
        self.init(deobfuscatedAtom)
    }
    
    public var syllables: [PhoneticBaseSyllable] {
        let obfuscatedAtom = PhoneticBaseObfuscator.obfuscate(atom)
        let bytes = obfuscatedAtom.serialize()
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
        case 1:
            return syllables
        case 2... where syllables.count.isOdd:
            return [.prefix(byte: 0)] + syllables
        default:
            return syllables
        }
    }
    
}

extension PatP {
    
    public enum Title: String, Codable {
        
        case galaxy = "czar"
        case star = "king"
        case planet = "duke"
        case moon = "earl"
        case comet = "pawn"
        
    }
    
    public var title: Title {
        switch bitWidth {
        case 0...8:
            return .galaxy
        case 9...16:
            return .star
        case 17...32:
            return .planet
        case 33...64:
            return .moon
        default:
            return .comet
        }
    }
    
    public var parent: PatP {
        switch title {
        case .galaxy:
            return self
        case .star:
            return self % 0x100
        case .planet:
            return self % 0x10000
        case .moon:
            return self % 0x100000000
        case .comet:
            return self % 0x10000
        }
    }
    
}
