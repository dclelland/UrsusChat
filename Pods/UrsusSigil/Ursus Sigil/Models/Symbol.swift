//
//  Symbol.swift
//  Alamofire
//
//  Created by Daniel Clelland on 14/07/20.
//

import Foundation

internal struct Symbol: Decodable {
    
    var element: Element
    var children: [Symbol]
    
    enum Name: String, Decodable {
        
        case rect
        case circle
        case line
        case path
        case group = "g"
    
    }
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case attributes
        case children
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch (try container.decode(Name.self, forKey: .name)) {
        case .rect:
            self.element = try container.decode(RectElement.self, forKey: .attributes)
        case .circle:
            self.element = try container.decode(CircleElement.self, forKey: .attributes)
        case .line:
            self.element = try container.decode(LineElement.self, forKey: .attributes)
        case .path:
            self.element = try container.decode(PathElement.self, forKey: .attributes)
        case .group:
            self.element = try container.decode(GroupElement.self, forKey: .attributes)
        }
        self.children = try container.decode([Symbol].self, forKey: .children)
    }
    
}

extension Symbol {
    
    static let bounds = CGRect(x: 0.0, y: 0.0, width: 128.0, height: 128.0)
    
    static var all: [String: Symbol] = {
        do {
            let data = try Data(contentsOf: Bundle.ursusSigil.urlForSymbols())
            let symbols = try JSONDecoder().decode([String: Symbol].self, from: data)
            return symbols
        } catch let error {
            print("[UrsusSigil] Error decoding symbols:", error)
            return [:]
        }
    }()
    
}

extension Symbol {
    
    func render(into context: CGContext, bounds: CGRect, foregroundColor: UIColor, backgroundColor: UIColor) {
        element.render(into: context, bounds: bounds, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        for element in children {
            element.render(into: context, bounds: bounds, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        }
    }
    
}
