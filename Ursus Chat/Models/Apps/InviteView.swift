//
//  InviteView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func inviteView(ship: String) -> InviteView {
        return app(ship: ship, app: "invite-view")
    }
    
}

class InviteView: UrsusApp {
    
    #warning("Implement decoder for InviteView.Primary")
    
    @discardableResult func primary(handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
}
