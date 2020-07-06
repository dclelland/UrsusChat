//
//  Keychain+Extensions.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 7/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import KeychainAccess

extension Keychain {
    
    static let shared = Keychain(service: Bundle.main.bundleIdentifier ?? "")
    
}

extension Keychain {
    
    func decodeData<T: Decodable>(_ type: T.Type, key: String, decoder: JSONDecoder = JSONDecoder()) throws -> T? {
        return try getData(key).map { data in
            return try decoder.decode(type, from: data)
        }
    }
    
    func encodeData<T: Encodable>(_ value: T, key: String, encoder: JSONEncoder = JSONEncoder()) throws {
        try set(try encoder.encode(value), key: key)
    }
    
}
