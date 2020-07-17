//
//  Sigil.swift
//  Ursus Sigil
//
//  Created by Daniel Clelland on 10/07/20.
//

import Foundation
import UrsusAtom

public struct Sigil {
    
    public var ship: PatP
    
    public var color: UIColor
    
    public init(ship: PatP, color: UIColor = .black) {
        self.ship = ship
        self.color = color
    }
    
}

extension Sigil {
    
    internal var symbols: [Symbol] {
        return ship.syllables.compactMap { syllable in
            return Symbol.all[syllable.rawValue]
        }
    }
    
}

extension Sigil {
    
    private static let origins: [Int: [CGPoint]] = [
        1: [
            CGPoint(x: 0.25, y: 0.25)
        ],
        2: [
            CGPoint(x: 0.0, y: 0.25),
            CGPoint(x: 0.5, y: 0.25)
        ],
        4: [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.5, y: 0.0),
            CGPoint(x: 0.0, y: 0.5),
            CGPoint(x: 0.5, y: 0.5)
        ]
    ]
    
    public func image(with size: CGSize) -> UIImage {
        let symbols = self.symbols
        
        return UIGraphicsImageRenderer(size: size).image { context in
            for (index, origin) in Sigil.origins[symbols.count, default: []].enumerated() {
                symbols[index].render(into: context.cgContext, bounds: CGRect(x: size.width * origin.x, y: size.height * origin.y, width: size.width * 0.5, height: size.height * 0.5), color: color)
            }
        }
    }
    
}
