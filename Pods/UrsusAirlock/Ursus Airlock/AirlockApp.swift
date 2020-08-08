//
//  AirlockApp.swift
//  Alamofire
//
//  Created by Daniel Clelland on 16/06/20.
//

import Foundation
import Alamofire

extension Airlock {
    
    public func app<T: AirlockApp>(ship: Ship, app: App) -> T {
        return T(airlock: self, ship: ship, app: app)
    }
    
}

open class AirlockApp {
    
    public var airlock: Airlock
    public var ship: Ship
    public var app: App
    
    required public init(airlock: Airlock, ship: Ship, app: App) {
        self.airlock = airlock
        self.ship = ship
        self.app = app
    }
    
}

extension AirlockApp {
    
    @discardableResult public func scryRequest(path: Path) -> DataRequest {
        return airlock.scryRequest(app: app, path: path)
    }
    
}

extension AirlockApp {
    
    @discardableResult public func ackRequest(eventID: Int) -> DataRequest {
        return airlock.ackRequest(eventID: eventID)
    }
    
    @discardableResult public func pokeRequest<JSON: Encodable>(mark: Mark = "json", json: JSON, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        return airlock.pokeRequest(ship: ship, app: app, mark: mark, json: json, handler: handler)
    }
    
    @discardableResult public func subscribeRequest(path: Path, handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        return airlock.subscribeRequest(ship: ship, app: app, path: path, handler: handler)
    }
    
    @discardableResult public func subscribeRequest<JSON: Decodable>(path: Path, handler: @escaping (SubscribeEvent<Result<JSON, Error>>) -> Void) -> DataRequest {
        return airlock.subscribeRequest(ship: ship, app: app, path: path, handler: handler)
    }
    
    @discardableResult public func unsubscribeRequest(subscriptionID: Int) -> DataRequest {
        return airlock.channelRequest(subscriptionID)
    }
    
    @discardableResult public func deleteRequest() -> DataRequest {
        return airlock.deleteRequest()
    }
    
}
