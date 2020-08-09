//
//  AirlockJSONDecoder.swift
//  Alamofire
//
//  Created by Daniel Clelland on 13/06/20.
//

import Foundation

public class AirlockJSONDecoder: JSONDecoder {
    
    public override init() {
        super.init()
        self.dateDecodingStrategy = .millisecondsSince1970
        self.dataDecodingStrategy = .jsonObject
    }
    
    public override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        userInfo[.jsonObject] = try JSONSerialization.jsonObject(with: data)
        let result = try super.decode(type, from: data)
        userInfo[.jsonObject] = nil
        return result
    }
    
}

extension JSONDecoder.DataDecodingStrategy {
    
    internal static var jsonObject: JSONDecoder.DataDecodingStrategy {
        return .custom { decoder -> Data in
            guard let object = decoder.userInfo[.jsonObject] else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Dynamic JSON object not set"))
            }
            
            let value: Any = try decoder.codingPath.reduce(object) { result, codingKey in
                switch codingKey.intValue {
                case .some(let intValue):
                    guard let array = result as? [Any] else {
                        throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Error decoding dynamic JSON object"))
                    }
                    
                    guard array.indices.contains(intValue) else {
                        throw DecodingError.keyNotFound(codingKey, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Error decoding dynamic JSON object"))
                    }
                    
                    return array[intValue]
                case .none:
                    guard let dictionary = result as? [String: Any] else {
                        throw DecodingError.typeMismatch([String: Any].self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Error decoding dynamic JSON object"))
                    }
                    
                    guard let value = dictionary[codingKey.stringValue] else {
                        throw DecodingError.keyNotFound(codingKey, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Error decoding dynamic JSON object"))
                    }
                    
                    return value
                }
            }

            return try JSONSerialization.data(withJSONObject: value)
        }
    }
    
}

extension CodingUserInfoKey {
    
    internal static let jsonObject = CodingUserInfoKey(rawValue: "jsonObject")!
    
}
