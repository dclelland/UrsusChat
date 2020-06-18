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
    
    #warning("Implement decoder for S3Store.AllResponse")
    
    @discardableResult func all(handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}
