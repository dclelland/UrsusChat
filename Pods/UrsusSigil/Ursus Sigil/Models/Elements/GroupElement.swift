//
//  GroupElement.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/07/20.
//

import Foundation

internal struct GroupElement: Element {
    
    var path: UIBezierPath
    var attributes: ElementAttributes
    
    init(from decoder: Decoder) throws {
        self.path = UIBezierPath()
        self.attributes = try ElementAttributes(from: decoder)
    }
    
}
