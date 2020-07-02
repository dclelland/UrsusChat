//
//  Sequence+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 2/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

extension Sequence {
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { lhs, rhs in
            return lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
        }
    }
    
}
