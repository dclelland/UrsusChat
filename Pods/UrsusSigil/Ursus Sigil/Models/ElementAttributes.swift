//
//  ElementAttributes.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation

internal struct ElementAttributes: Decodable {
    
    internal enum Color: String, Decodable {
        
        case none
        case foreground = "@FG"
        case background = "@BG"
        
    }
    
    private enum LineCap: String, Decodable {
        
        case butt
        case round
        case square
        
        var lineCap: CGLineCap {
            switch self {
            case .butt:
                return .butt
            case .round:
                return .round
            case .square:
                return .square
            }
        }
        
    }
    
    private enum FillRule: String, Decodable {
        
        case nonzero
        case evenodd
        
        var fillRule: CGPathFillRule {
            switch self {
            case .nonzero:
                return .winding
            case .evenodd:
                return .evenOdd
            }
        }
        
    }
    
    var stroke: Color
    var strokeWidth: CGFloat
    var strokeLineCap: CGLineCap
    var fill: Color
    var fillRule: CGPathFillRule
    var clipRule: CGPathFillRule
    var transform: CGAffineTransform
    
    enum CodingKeys: String, CodingKey {

        case stroke
        case strokeWidth = "stroke-width"
        case strokeLineCap = "stroke-linecap"
        case fill
        case fillRule = "fill-rule"
        case clipRule = "clip-rule"
        case transform

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stroke = try container.decodeIfPresent(Color.self, forKey: .stroke) ?? .none
        self.strokeWidth = try container.decodeIfPresent(String.self, forKey: .strokeWidth).flatMap { Double($0) }.flatMap { CGFloat($0) } ?? 0.0
        self.strokeLineCap = try container.decodeIfPresent(LineCap.self, forKey: .strokeLineCap)?.lineCap ?? .butt
        self.fill = try container.decodeIfPresent(Color.self, forKey: .fill) ?? .none
        self.fillRule = try container.decodeIfPresent(FillRule.self, forKey: .fillRule)?.fillRule ?? .winding
        self.clipRule = try container.decodeIfPresent(FillRule.self, forKey: .clipRule)?.fillRule ?? .winding
        self.transform = try container.decodeIfPresent(String.self, forKey: .transform).flatMap { CGAffineTransform(transformString: $0) } ?? .identity
    }
    
}
