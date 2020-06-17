//
//  UrsusApp.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/06/20.
//

import Foundation
import Alamofire

extension Ursus {
    
    public func app<App: UrsusApp>(ship: String, app: String) -> App {
        return App(ursus: self, ship: ship, app: app)
    }
    
}

open class UrsusApp {
    
    public var ursus: Ursus
    public var ship: String
    public var app: String
    
    required public init(ursus: Ursus, ship: String, app: String) {
        self.ursus = ursus
        self.ship = ship
        self.app = app
    }
    
}

extension UrsusApp {
    
    @discardableResult public func ackRequest(eventID: Int) -> DataRequest {
        return ursus.ackRequest(eventID: eventID)
    }
    
    @discardableResult public func pokeRequest<JSON: Encodable>(mark: String = "json", json: JSON, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        return ursus.pokeRequest(ship: ship, app: app, mark: mark, json: json, handler: handler)
    }
    
    @discardableResult public func subscribeRequest(path: String, handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        return ursus.subscribeRequest(ship: ship, app: app, path: path, handler: handler)
    }
    
    @discardableResult public func subscribeRequest<JSON: Decodable>(path: String, handler: @escaping (SubscribeEvent<JSON>) -> Void) -> DataRequest {
        return ursus.subscribeRequest(ship: ship, app: app, path: path, handler: handler)
    }
    
    @discardableResult public func unsubscribeRequest(subscriptionID: Int) -> DataRequest {
        return ursus.channelRequest(subscriptionID)
    }
    
    @discardableResult public func deleteRequest() -> DataRequest {
        return ursus.deleteRequest()
    }
    
}
