//
//  LineElement.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation

internal struct LineElement: Element {
    
    var path: UIBezierPath
    var attributes: ElementAttributes
    
    enum CodingKeys: String, CodingKey {

        case x1
        case y1
        case x2
        case y2

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x1 = try container.decodeIfPresent(String.self, forKey: .x1).flatMap { Double($0) } ?? 0.0
        let y1 = try container.decodeIfPresent(String.self, forKey: .y1).flatMap { Double($0) } ?? 0.0
        let x2 = try container.decodeIfPresent(String.self, forKey: .x2).flatMap { Double($0) } ?? 0.0
        let y2 = try container.decodeIfPresent(String.self, forKey: .y2).flatMap { Double($0) } ?? 0.0
        self.path = UIBezierPath()
        self.path.move(to: CGPoint(x: x1, y: y1))
        self.path.addLine(to: CGPoint(x: x2, y: y2))
        self.attributes = try ElementAttributes(from: decoder)
    }
    
}
