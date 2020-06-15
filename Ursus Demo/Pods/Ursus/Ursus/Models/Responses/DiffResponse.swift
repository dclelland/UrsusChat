//
//  DiffResponse.swift
//  Ursus
//
//  Created by Daniel Clelland on 7/06/20.
//

import Foundation

internal struct DiffResponse: Decodable {
    
    var id: Int
    var json: Data
    
    enum CodingKeys: String, CodingKey {
        case id
        case json
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.json = try JSONSerialization.data(withJSONObject: (decoder.userInfo[.json] as? [String: Any])?[CodingKeys.json.rawValue] as Any)
    }
    
}
