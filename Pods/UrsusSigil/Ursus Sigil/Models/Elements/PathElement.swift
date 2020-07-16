//
//  PathElement.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation
import SwiftSVG

internal struct PathElement: Element {
    
    var path: UIBezierPath
    var attributes: ElementAttributes
    
    enum CodingKeys: String, CodingKey {

        case d

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let d = try container.decodeIfPresent(String.self, forKey: .d) ?? ""
        self.path = UIBezierPath(pathString: d)
        self.attributes = try ElementAttributes(from: decoder)
    }
    
}
