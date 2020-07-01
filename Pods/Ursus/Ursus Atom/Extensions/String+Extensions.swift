//
//  Array+Extensions.swift
//  Alamofire
//
//  Created by Daniel Clelland on 26/06/20.
//

import Foundation

extension String {
    
    internal init<T: BinaryInteger>(_ value: T, radix: Int = 10, chunk: Int, separator: String = ".") {
        self = String(String(value, radix: radix).reversed().chunked(by: chunk).joined(separator: separator).reversed())
    }
    
}

extension String {
    
    internal func chunked(by size: Int) -> [String] {
        return Array(self).chunked(by: size).map { String($0) }
    }
    
}

extension Collection where Index == Int {
    
    internal func chunked(by size: Index.Stride) -> [SubSequence] {
        return stride(from: startIndex, to: endIndex, by: size).map { index in
            let newIndex = self.index(index, offsetBy: size, limitedBy: endIndex) ?? endIndex
            return self[index..<newIndex]
        }
    }
    
}
