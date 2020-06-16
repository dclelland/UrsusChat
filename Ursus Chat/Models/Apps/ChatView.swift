//
//  ChatViewApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 16/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

extension Ursus {
    
    func chatView(ship: String) -> ChatView {
        return app(ship: ship, app: "chat-view")
    }
    
}

class ChatView: UrsusApp {
    
    @discardableResult func primary(handler: @escaping (SubscribeEvent) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
}
