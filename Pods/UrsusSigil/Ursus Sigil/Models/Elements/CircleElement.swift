//
//  CircleElement.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation

internal struct CircleElement: Element {
    
    var path: UIBezierPath
    var attributes: ElementAttributes
    
    enum CodingKeys: String, CodingKey {

        case cx
        case cy
        case r

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cx = try container.decodeIfPresent(String.self, forKey: .cx).flatMap { Double($0) } ?? 0.0
        let cy = try container.decodeIfPresent(String.self, forKey: .cy).flatMap { Double($0) } ?? 0.0
        let r = try container.decodeIfPresent(String.self, forKey: .r).flatMap { Double($0) } ?? 0.0
        self.path = UIBezierPath(ovalIn: CGRect(x: cx - r, y: cy - r, width: r * 2.0, height: r * 2.0))
        self.attributes = try ElementAttributes(from: decoder)
    }
    
}
