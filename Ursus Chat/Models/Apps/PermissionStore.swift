//
//  PermissionStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func permissionStore(ship: String) -> PermissionStore {
        return app(ship: ship, app: "permission-store")
    }
    
}

class PermissionStore: UrsusApp {
    
    #warning("Implement decoder for PermissionStore.All")
    
    @discardableResult func all(handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}
