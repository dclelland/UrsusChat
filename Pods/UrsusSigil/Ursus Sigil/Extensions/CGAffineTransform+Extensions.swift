//
//  CGAffineTransform+Extensions.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation

extension CGAffineTransform {
    
    internal init?(transformString: String) {
        guard transformString.hasPrefix("matrix(") && transformString.hasSuffix(")") else {
            return nil
        }
        
        let coordinates = transformString.dropFirst(7).dropLast(1).components(separatedBy: " ").compactMap { coordinate in
            return Double(coordinate).flatMap { CGFloat($0) }
        }
        
        guard coordinates.count == 6 else {
            return nil
        }
        
        self.init(
            a: coordinates[0],
            b: coordinates[1],
            c: coordinates[2],
            d: coordinates[3],
            tx: coordinates[4],
            ty: coordinates[5]
        )
    }
    
}

extension CGAffineTransform {
    
    internal init(from source: CGRect, to destination: CGRect) {
        guard source.width.isNormal, source.height.isNormal else {
            self = .identity
            return
        }
        
        self.init(
            a: destination.width / source.width,
            b: 0.0,
            c: 0.0,
            d: destination.height / source.height,
            tx: (destination.minX * source.width - source.minX * destination.width) / source.width,
            ty: (destination.minY * source.height - source.minY * destination.height) / source.height
        )
    }
    
}
