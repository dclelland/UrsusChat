//
//  WrappedUnsignedInteger.swift
//  Alamofire
//
//  Created by Daniel Clelland on 27/06/20.
//

import Foundation

internal protocol WrappedUnsignedInteger: UnsignedInteger {
    
    associatedtype Value: UnsignedInteger
    
    var value: Value { get }

    init(_ value: Value)
    
}

extension WrappedUnsignedInteger {
    
    public init() {
        self.init(.zero)
    }
    
}

extension WrappedUnsignedInteger {
    
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(Value(integerLiteral: value))
    }
    
}

extension WrappedUnsignedInteger {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
    
}

extension WrappedUnsignedInteger {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
    
}

extension WrappedUnsignedInteger {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
}

extension WrappedUnsignedInteger {
    
    public func advanced(by n: Int) -> Self {
        return Self(value.advanced(by: n))
    }
    
    public func distance(to other: Self) -> Int {
        return value.distance(to: other.value)
    }
    
}

extension WrappedUnsignedInteger {
    
    public init<T>(_ source: T) where T : BinaryInteger {
        self.init(Value(source))
    }
    
    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        self.init(Value(source))
    }
    
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        guard let value = Value(exactly: source) else {
            return nil
        }

        self.init(value)
    }
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let value = Value(exactly: source) else {
            return nil
        }
        
        self.init(value)
    }
    
    public init<T>(clamping source: T) where T : BinaryInteger {
        self.init(Value(clamping: source))
    }

    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        self.init(Value(truncatingIfNeeded: source))
    }
    
    public var bitWidth: Int {
        return value.bitWidth
    }
    
    public var trailingZeroBitCount: Int {
        return value.trailingZeroBitCount
    }
    
    public var words: Value.Words {
        return value.words
    }
    
    public static var isSigned: Bool {
        return Value.isSigned
    }
    
    public static func % (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value % rhs.value)
    }
    
    public static func %= (lhs: inout Self, rhs: Self) {
        lhs = lhs % rhs
    }
    
    public static func & (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value & rhs.value)
    }
    
    public static func &= (lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value * rhs.value)
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value + rhs.value)
    }
    
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value - rhs.value)
    }
    
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    public static func / (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value / rhs.value)
    }
    
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    public static func << <RHS>(lhs: Self, rhs: RHS) -> Self where RHS : BinaryInteger {
        return Self(lhs.value << rhs)
    }
    
    public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs = lhs << rhs
    }
    
    public static func >> <RHS>(lhs: Self, rhs: RHS) -> Self where RHS : BinaryInteger {
        return Self(lhs.value >> rhs)
    }
    
    public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs = lhs >> rhs
    }
    
    public static func ^ (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value ^ rhs.value)
    }
    
    public static func ^= (lhs: inout Self, rhs: Self) {
        lhs = lhs ^ rhs
    }
    
    public static func | (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value | rhs.value)
    }
    
    public static func |= (lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }
    
    public static prefix func ~ (x: Self) -> Self {
        return Self(~x.value)
    }

}
