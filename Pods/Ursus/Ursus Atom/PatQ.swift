//
//  PatQ.swift
//  Alamofire
//
//  Created by Daniel Clelland on 27/06/20.
//

import Foundation
import BigInt

public struct PatQ: Aura {
    
    internal var atom: BigUInt

    internal init(_ atom: BigUInt) {
        self.atom = atom
    }
    
}

extension PatQ {
    
    public init(string: String) throws {
        let bytes = try PhoneticBaseParser.parse(string)
        let atom = BigUInt(Data(bytes))
        self.init(atom)
    }
    
}

extension PatQ: CustomStringConvertible {
    
    public var description: String {
        let bytes: [UInt8] = Array(atom.serialize())
        return PhoneticBaseParser.render(bytes: bytes, padding: .noPadding, spacing: .shortSpacing)
    }
    
}

extension PatQ: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return ".~" + description
    }
    
}

extension PatQ: ExpressibleByStringLiteral {
    
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

extension PatQ: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(string: try container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
    
}
