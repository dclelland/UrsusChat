//
//  UrsusDecoder.swift
//  Alamofire
//
//  Created by Daniel Clelland on 13/06/20.
//

import Foundation

public class UrsusDecoder: JSONDecoder {
    
    public override init() {
        super.init()
        self.dateDecodingStrategy = .millisecondsSince1970
        self.dataDecodingStrategy = .jsonObject
        self.keyDecodingStrategy = .convertFromKebabCase
    }
    
    public override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        userInfo[.jsonObject] = try JSONSerialization.jsonObject(with: data)
        let result = try super.decode(type, from: data)
        userInfo[.jsonObject] = nil
        return result
    }
    
}

extension JSONDecoder.DataDecodingStrategy {
    
    public static var jsonObject: JSONDecoder.DataDecodingStrategy {
        return .custom { decoder -> Data in
            let jsonObject: Any? = decoder.codingPath.reduce(decoder.userInfo[.jsonObject]) { result, codingKey in
                switch codingKey.intValue {
                case .some(let intValue):
                    return (result as? [Any])?[intValue]
                case .none:
                    return (result as? [String: Any])?[codingKey.stringValue]
                }
            }
            
            return try JSONSerialization.data(withJSONObject: jsonObject as Any)
        }
    }
    
}

extension JSONDecoder.KeyDecodingStrategy {
    
    public static var convertFromKebabCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys -> CodingKey in
            let codingKey = codingKeys.last!
            switch codingKey.intValue {
            case .some(let intValue):
                return CamelCasedCodingKey(intValue: intValue)!
            case .none:
                return CamelCasedCodingKey(stringValue: codingKey.stringValue)!
            }
        }
    }
    
}

private struct CamelCasedCodingKey: CodingKey {
    
    var stringValue: String
    
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue.convertFromKebabCase
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
    
}

extension String {
    
    internal var convertFromKebabCase: String {
        let pascalCase = capitalized.replacingOccurrences(of: "-", with: "")
        return pascalCase.first?.lowercased().appending(pascalCase.dropFirst()) ?? ""
    }
    
}

extension CodingUserInfoKey {
    
    internal static let jsonObject = CodingUserInfoKey(rawValue: "jsonObject")!
    
}
