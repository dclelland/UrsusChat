//
//  S3Store.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func s3Store(ship: String) -> S3Store {
        return app(ship: ship, app: "s3-store")
    }
    
}

class S3Store: UrsusApp {
    
    @discardableResult func all(handler: @escaping (SubscribeEvent<AllResponse>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}

extension S3Store {
    
    enum AllResponse: Decodable {
        
        case s3Update(S3Update)
        
        enum CodingKeys: String, CodingKey {
            
            case s3Update
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.s3Update]:
                self = .s3Update(try container.decode(S3Update.self, forKey: .s3Update))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}

extension S3Store {
    
    struct Credentials: Decodable {
        
//        var endpoint: String
//        var accessKeyID: String
//        var secretAccessKey: String
//
//        enum CodingKeys: String, CodingKey {
//
//            case endpoint = "endpoint"
//            case accessKeyID = "accessKeyId"
//            case secretAccessKey = "secretAccessKey"
//
//        }
        
    }
    
    struct Configuration: Decodable {
        
//        var buckets: Set<String>
//        var currentBucket: String
//
//        enum CodingKeys: String, CodingKey {
//
//            case buckets = "buckets"
//            case currentBucket = "currentBucket"
//
//        }
        
    }
    
    enum S3Update: Decodable {
        
        #warning("Implement decoder for S3Store.S3Update: Several cases remaining; issues with CodingKeys")
        
        case credentials(Credentials)
        case configuration(Configuration)
        
        enum CodingKeys: String, CodingKey {
            
            case credentials
            case configuration
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.credentials]:
                self = .credentials(try container.decode(Credentials.self, forKey: .credentials))
            case [.configuration]:
                self = .configuration(try container.decode(Configuration.self, forKey: .configuration))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
