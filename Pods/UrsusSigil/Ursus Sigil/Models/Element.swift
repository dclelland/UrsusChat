//
//  Element.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation

internal protocol Element: Decodable {
    
    var path: UIBezierPath { get }

    var attributes: ElementAttributes { get }
    
}

extension Element {
    
    func render(into context: CGContext, bounds: CGRect, foregroundColor: UIColor, backgroundColor: UIColor) {
        let transformedPath = path.applying(attributes.transform).applying(CGAffineTransform(from: Symbol.bounds, to: bounds))
        
        context.draw { context in
            context.setFillColor(attributes.fill.color(foregroundColor: foregroundColor, backgroundColor: backgroundColor).cgColor)
            context.addPath(transformedPath.cgPath)
            context.fillPath(using: attributes.fillRule)
            
            context.setStrokeColor(attributes.stroke.color(foregroundColor: foregroundColor, backgroundColor: backgroundColor).cgColor)
            context.setLineWidth(bounds.width / 128.0 + 0.33)
            context.setLineCap(attributes.strokeLineCap)
            context.addPath(transformedPath.cgPath)
            context.strokePath()
        }
    }
    
}
