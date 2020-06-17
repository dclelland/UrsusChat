//
//  ContactView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func permissionStore(ship: String) -> ContactView {
        return app(ship: ship, app: "contact-view")
    }
    
}

class ContactView: UrsusApp {
    
    #warning("Implement decoder for ContactView.Primary")
    
    @discardableResult func primary(handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
}
