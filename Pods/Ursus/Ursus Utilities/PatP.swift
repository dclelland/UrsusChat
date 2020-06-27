//
//  PatP.swift
//  Alamofire
//
//  Created by Daniel Clelland on 27/06/20.
//

import Foundation
import BigInt

public struct PatP: WrappedUnsignedInteger {
    
    internal var value: BigUInt

    internal init(_ value: BigUInt) {
        self.value = value
    }
    
}

extension PatP {
    
    public enum Title {
        
        case galaxy
        case star
        case planet
        case moon
        case comet
        
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
    
}

extension PatP {
    
    public init(string: String) throws {
        let bytes = try PhoneticBaseParser.parse(string)
        let deobfuscatedValue = PhoneticBaseObfuscator.deobfuscate(BigUInt(Data(bytes)))
        self.init(deobfuscatedValue)
    }
    
}

extension PatP: CustomStringConvertible {
    
    public var description: String {
        let obfuscatedValue = PhoneticBaseObfuscator.obfuscate(value)
        let bytes: [UInt8] = Array(obfuscatedValue.serialize())
        return PhoneticBaseParser.render(bytes: bytes, padding: .padding, spacing: .longSpacing)
    }
    
}

extension PatP: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "~" + description
    }
    
}

extension PatP: ExpressibleByStringLiteral {
    
    public init(unicodeScalarLiteral value: String.ExtendedGraphemeClusterLiteralType) {
        try! self.init(string: String(unicodeScalarLiteral: value))
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        try! self.init(string: String(extendedGraphemeClusterLiteral: value))
    }

    public init(stringLiteral value: StringLiteralType) {
        try! self.init(string: String(stringLiteral: value))
    }
    
}

extension PatP: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(string: try container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
    
}
