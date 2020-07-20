//
//  Aura.swift
//  Ursus Aura
//
//  Created by Daniel Clelland on 27/06/20.
//

import Foundation

internal protocol Aura: UnsignedInteger, RawRepresentable, Codable, ExpressibleByStringLiteral {
    
    associatedtype Atom: UnsignedInteger
    
    var atom: Atom { get }
    
    var string: String { get }

    init(atom: Atom)
    
    init(string: String) throws
    
}

extension Aura {
    
    public init() {
        self.init(atom: .zero)
    }
    
}

extension Aura {
    
    public init?(rawValue: String) {
        try? self.init(string: rawValue)
    }
    
    public var rawValue: String {
        return string
    }
    
}

extension Aura {
    
    public var description: String {
        return rawValue
    }
    
}

extension Aura {
    
    public init(integerLiteral value: Atom.IntegerLiteralType) {
        self.init(atom: Atom(integerLiteral: value))
    }
    
}

extension Aura {
    
    public init(unicodeScalarLiteral value: String.ExtendedGraphemeClusterLiteralType) {
        try! self.init(string: String(unicodeScalarLiteral: value))
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        try! self.init(string: String(extendedGraphemeClusterLiteral: value))
    }

    public init(stringLiteral value: String) {
        try! self.init(string: String(stringLiteral: value))
    }
    
}

extension Aura {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.atom == rhs.atom
    }
    
}

extension Aura {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.atom < rhs.atom
    }
    
}

extension Aura {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(atom)
    }
    
}

extension Aura {
    
    public func advanced(by n: Int) -> Self {
        return Self(atom: atom.advanced(by: n))
    }
    
    public func distance(to other: Self) -> Int {
        return atom.distance(to: other.atom)
    }
    
}

extension Aura {
    
    public init<T>(_ source: T) where T : BinaryInteger {
        self.init(atom: Atom(source))
    }
    
    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        self.init(atom: Atom(source))
    }
    
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        guard let atom = Atom(exactly: source) else {
            return nil
        }

        self.init(atom: atom)
    }
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let atom = Atom(exactly: source) else {
            return nil
        }
        
        self.init(atom: atom)
    }
    
    public init<T>(clamping source: T) where T : BinaryInteger {
        self.init(atom: Atom(clamping: source))
    }

    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        self.init(atom: Atom(truncatingIfNeeded: source))
    }
    
    public var bitWidth: Int {
        return atom.bitWidth
    }
    
    public var trailingZeroBitCount: Int {
        return atom.trailingZeroBitCount
    }
    
    public var words: Atom.Words {
        return atom.words
    }
    
    public static var isSigned: Bool {
        return Atom.isSigned
    }
    
    public static func % (lhs: Self, rhs: Self) -> Self {
        return Self(atom: lhs.atom % rhs.atom)
    }
    
    public static func %= (lhs: inout Self, rhs: Self) {
        lhs = lhs % rhs
    }
    
    public static func & (lhs: Self, rhs: Self) -> Self {
        return Self(atom: lhs.atom & rhs.atom)
    }
    
    public static func &= (lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self(atom: lhs.atom * rhs.atom)
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(atom: lhs.atom + rhs.atom)
    }
    
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(atom: lhs.atom - rhs.atom)
    }
    
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    public static func / (lhs: Self, rhs: Self) -> Self {
        return Self(atom: lhs.atom / rhs.atom)
    }
    
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    public static func << <RHS>(lhs: Self, rhs: RHS) -> Self where RHS : BinaryInteger {
        return Self(atom: lhs.atom << rhs)
    }
    
    public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs = lhs << rhs
    }
    
    public static func >> <RHS>(lhs: Self, rhs: RHS) -> Self where RHS : BinaryInteger {
        return Self(atom: lhs.atom >> rhs)
    }
    
    public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs = lhs >> rhs
    }
    
    public static func ^ (lhs: Self, rhs: Self) -> Self {
        return Self(atom: lhs.atom ^ rhs.atom)
    }
    
    public static func ^= (lhs: inout Self, rhs: Self) {
        lhs = lhs ^ rhs
    }
    
    public static func | (lhs: Self, rhs: Self) -> Self {
        return Self(atom: lhs.atom | rhs.atom)
    }
    
    public static func |= (lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }
    
    public static prefix func ~ (x: Self) -> Self {
        return Self(atom: ~x.atom)
    }

}
