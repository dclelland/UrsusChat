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
    
    func render(into context: CGContext, bounds: CGRect, color: UIColor) {
        let transformedPath = path.applying(attributes.transform).applying(CGAffineTransform(from: Symbol.bounds, to: bounds))
        
        context.draw { context in
            switch attributes.fill {
            case .none:
                break
            case .foreground:
                context.setFillColor(color.cgColor)
                context.addPath(transformedPath.cgPath)
                context.fillPath(using: attributes.fillRule)
            case .background:
                context.setBlendMode(.clear)
                context.addPath(transformedPath.cgPath)
                context.fillPath(using: attributes.clipRule)
            }
        }
        
        context.draw { context in
            switch attributes.stroke {
            case .none:
                break
            case .foreground:
                context.setLineWidth(bounds.width / 128.0 + 0.33)
                context.setLineCap(attributes.strokeLineCap)
                context.setStrokeColor(color.cgColor)
                context.addPath(transformedPath.cgPath)
                context.strokePath()
            case .background:
                context.setLineWidth(bounds.width / 128.0 + 0.33)
                context.setLineCap(attributes.strokeLineCap)
                context.setBlendMode(.clear)
                context.addPath(transformedPath.cgPath)
                context.strokePath()
            }
        }
    }
    
}
