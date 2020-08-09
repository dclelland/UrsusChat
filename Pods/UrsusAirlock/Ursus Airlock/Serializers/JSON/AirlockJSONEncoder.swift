//
//  AirlockJSONEncoder.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/06/20.
//

import Foundation

public class AirlockJSONEncoder: JSONEncoder {
    
    public override init() {
        super.init()
        self.dateEncodingStrategy = .integerMillisecondsSince1970
    }
    
}

extension JSONEncoder.DateEncodingStrategy {
    
    internal static var integerMillisecondsSince1970: JSONEncoder.DateEncodingStrategy {
        return .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(Int(date.timeIntervalSince1970 * 1000.0))
        }
    }
    
}
