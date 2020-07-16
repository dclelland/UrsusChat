//
//  UIBezierPath+Extensions.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation

extension UIBezierPath {
    
    func applying(_ transform: CGAffineTransform) -> UIBezierPath {
        let path = copy() as! UIBezierPath
        path.apply(transform)
        return path
    }
    
}
