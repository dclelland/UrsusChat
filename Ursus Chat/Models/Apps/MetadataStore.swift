//
//  MetadataStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func metadataStore(ship: String) -> MetadataStore {
        return app(ship: ship, app: "metadata-store")
    }
    
}

class MetadataStore: UrsusApp {
    
    #warning("Implement decoder for MetadataStore.AppNameResponse")
    
    @discardableResult func appName(app: String, handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/app-name/\(app)", handler: handler)
    }
    
}
