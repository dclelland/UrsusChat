//
//  String+Extensions.swift
//  Alamofire
//
//  Created by Daniel Clelland on 12/06/20.
//

import Foundation
import BigInt

extension UUID {
    
    public var base32String: String {
        return BigUInt(words: [upperBits, lowerBits]).base32String
    }
    
}

extension UUID {
    
    internal var upperBits: UInt {
        let upperBytes = [uuid.0, uuid.1, uuid.2, uuid.3, uuid.4, uuid.5, uuid.6, uuid.7]
        return upperBytes.reduce(0) { result, byte in
            return result << 8 + UInt(byte)
        }
    }
    
    internal var lowerBits: UInt {
        let lowerBytes = [uuid.8, uuid.9, uuid.10, uuid.11, uuid.12, uuid.13, uuid.14, uuid.15]
        return lowerBytes.reduce(0) { result, byte in
            return result << 8 + UInt(byte)
        }
    }
    
}

extension BinaryInteger {
    
    internal var base32String: String {
        return "0v" + String(self, radix: 32, chunk: 5)
    }
    
}

extension String {
    
    internal init<T: BinaryInteger>(_ value: T, radix: Int = 10, chunk: Int, separator: String = ".") {
        self = String(String(value, radix: radix).reversed().chunked(by: chunk).joined(separator: separator).reversed())
    }
    
}

extension Array {
    
    internal func chunked(by distance: Int) -> [[Element]] {
        return stride(from: startIndex, to: endIndex, by: distance).map { index in
            let newIndex = index.advanced(by: distance) > endIndex ? endIndex : index.advanced(by: distance)
            return Array(self[index..<newIndex])
        }
    }
    
}
