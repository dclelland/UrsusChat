//
//  Sigil.swift
//  Ursus Sigil
//
//  Created by Daniel Clelland on 10/07/20.
//

import Foundation
import UrsusAtom

public struct Sigil {

    public typealias Ship = PatP
    
    public var ship: Ship
    
    public var color: UIColor
    
    public init(ship: Ship, color: UIColor = .black) {
        self.ship = ship
        self.color = color
    }
    
}

extension Sigil {
    
    public func image(with size: CGSize) -> UIImage {
        let symbols = self.symbols
        
        return UIGraphicsImageRenderer(size: size).image { context in
            for (index, cell) in Sigil.grids[ship.title, default: []].enumerated() {
                let bounds = CGRect(x: size.width * cell.minX, y: size.height * cell.minY, width: size.width * cell.width, height: size.height * cell.height)
                symbols[index].render(into: context.cgContext, bounds: bounds, color: color)
            }
        }
    }
    
}

extension Sigil {
    
    private var symbols: [Symbol] {
        return ship.syllables.compactMap { syllable in
            return Symbol.all[syllable.rawValue]
        }
    }
    
    private static let grids: [Ship.Title: [CGRect]] = [
        .galaxy: [
            CGRect(x: 0.25, y: 0.25, width: 0.50, height: 0.50)
        ],
        .star: [
            CGRect(x: 0.00, y: 0.25, width: 0.50, height: 0.50),
            CGRect(x: 0.50, y: 0.25, width: 0.50, height: 0.50)
        ],
        .planet: [
            CGRect(x: 0.00, y: 0.00, width: 0.50, height: 0.50),
            CGRect(x: 0.50, y: 0.00, width: 0.50, height: 0.50),
            CGRect(x: 0.00, y: 0.50, width: 0.50, height: 0.50),
            CGRect(x: 0.50, y: 0.50, width: 0.50, height: 0.50)
        ],
        .moon: [
            CGRect(x: 0.00, y: 0.25, width: 0.25, height: 0.25),
            CGRect(x: 0.25, y: 0.25, width: 0.25, height: 0.25),
            CGRect(x: 0.00, y: 0.50, width: 0.25, height: 0.25),
            CGRect(x: 0.25, y: 0.50, width: 0.25, height: 0.25),
            CGRect(x: 0.50, y: 0.25, width: 0.25, height: 0.25),
            CGRect(x: 0.75, y: 0.25, width: 0.25, height: 0.25),
            CGRect(x: 0.50, y: 0.50, width: 0.25, height: 0.25),
            CGRect(x: 0.75, y: 0.50, width: 0.25, height: 0.25),
        ],
        .comet: [
            CGRect(x: 0.00, y: 0.00, width: 0.25, height: 0.25),
            CGRect(x: 0.25, y: 0.00, width: 0.25, height: 0.25),
            CGRect(x: 0.00, y: 0.25, width: 0.25, height: 0.25),
            CGRect(x: 0.25, y: 0.25, width: 0.25, height: 0.25),
            CGRect(x: 0.50, y: 0.00, width: 0.25, height: 0.25),
            CGRect(x: 0.75, y: 0.00, width: 0.25, height: 0.25),
            CGRect(x: 0.50, y: 0.25, width: 0.25, height: 0.25),
            CGRect(x: 0.75, y: 0.25, width: 0.25, height: 0.25),
            CGRect(x: 0.00, y: 0.50, width: 0.25, height: 0.25),
            CGRect(x: 0.25, y: 0.50, width: 0.25, height: 0.25),
            CGRect(x: 0.00, y: 0.75, width: 0.25, height: 0.25),
            CGRect(x: 0.25, y: 0.75, width: 0.25, height: 0.25),
            CGRect(x: 0.50, y: 0.50, width: 0.25, height: 0.25),
            CGRect(x: 0.75, y: 0.50, width: 0.25, height: 0.25),
            CGRect(x: 0.50, y: 0.75, width: 0.25, height: 0.25),
            CGRect(x: 0.75, y: 0.75, width: 0.25, height: 0.25)
        ]
    ]
    
}
