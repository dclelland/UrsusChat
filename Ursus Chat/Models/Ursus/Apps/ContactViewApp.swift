//
//  ContactViewApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func contactView(ship: Ship) -> ContactViewApp {
        return app(ship: ship, app: "contact-view")
    }
    
}

class ContactViewApp: UrsusApp {
    
    @discardableResult func primary(handler: @escaping (SubscribeEvent<PrimaryResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
}

extension ContactViewApp {
    
    enum PrimaryResponse: Decodable {
        
        case contactUpdate(ContactUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case contactUpdate
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.contactUpdate]:
                self = .contactUpdate(try container.decode(ContactUpdate.self, forKey: .contactUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
