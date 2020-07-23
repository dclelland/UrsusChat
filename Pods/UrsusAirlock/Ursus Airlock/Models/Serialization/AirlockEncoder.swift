//
//  AirlockEncoder.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/06/20.
//

import Foundation

public class AirlockEncoder: JSONEncoder {
    
    public override init() {
        super.init()
        self.dateEncodingStrategy = .integerMillisecondsSince1970
        self.keyEncodingStrategy = .convertToKebabCase
    }
    
}

extension JSONEncoder.DateEncodingStrategy {
    
    public static var integerMillisecondsSince1970: JSONEncoder.DateEncodingStrategy {
        return .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(Int(date.timeIntervalSince1970 * 1000.0))
        }
    }
    
}

extension JSONEncoder.KeyEncodingStrategy {
    
    public static var convertToKebabCase: JSONEncoder.KeyEncodingStrategy {
        return .custom { codingKeys -> CodingKey in
            let codingKey = codingKeys.last!
            switch codingKey.intValue {
            case .some(let intValue):
                return KebabCasedCodingKey(intValue: intValue)!
            case .none:
                return KebabCasedCodingKey(stringValue: codingKey.stringValue)!
            }
        }
    }
    
}

private struct KebabCasedCodingKey: CodingKey {
    
    var stringValue: String
    
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue.convertToKebabCase
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
    
}

extension String {
    
    internal var convertToKebabCase: String {
        return replacingOccurrences(of: "([a-z])([A-Z])", with: "$1-$2", options: .regularExpression).lowercased()
    }
    
}
