//
//  Airlock.swift
//  Ursus
//
//  Created by Daniel Clelland on 3/06/20.
//

import Foundation
import Alamofire
import UrsusAtom

public typealias Ship = PatP

public typealias Code = PatP

public class Airlock {
    
    private var session: Session = .default
    private var eventSource: EventSource? = nil
    
    private var encoder = AirlockEncoder()
    private var decoder = AirlockDecoder()
    
    private var pokeHandlers = [Int: (PokeEvent) -> Void]()
    private var subscribeHandlers = [Int: (SubscribeEvent<Data>) -> Void]()
    
    private var uid: String = Airlock.uid()
    
    private var requestID: Int = 0
    private var nextRequestID: Int {
        requestID += 1
        return requestID
    }
    
    private var lastEventID: String? = nil
    
    public var credentials: AirlockCredentials
    
    public init(credentials: AirlockCredentials) {
        self.credentials = credentials
    }
    
    public convenience init(url: URL, code: Code) {
        self.init(credentials: AirlockCredentials(url: url, code: code))
    }
    
    deinit {
        deleteRequest()
    }
    
}

extension Airlock {
    
    @discardableResult public func loginRequest(handler: @escaping (Ship) -> Void) -> DataRequest {
        return session.request(loginURL, method: .post, parameters: ["password": Code.Prefixless(credentials.code)], encoder: URLEncodedFormParameterEncoder.default).validate().response { response in
            guard case .success = response.result else {
                print("[Ursus] Error with login request")
                return
            }
            
            guard let urbauth = response.response?.value(forHTTPHeaderField: "Set-Cookie") else {
                print("[Ursus] Error retrieving urbauth")
                return
            }
            
            guard let name = urbauth.split(separator: "=").first?.replacingOccurrences(of: "urbauth-", with: "") else {
                print("[Ursus] Error decoding urbauth:", urbauth)
                return
            }
            
            guard let ship = Ship(rawValue: name) else {
                print("[Ursus] Error decoding urbauth:", urbauth)
                return
            }
            
            handler(ship)
        }
    }
    
    @discardableResult public func logoutRequest() -> DataRequest {
        return session.request(logoutURL, method: .post).validate()
    }
    
    @discardableResult public func channelRequest<Parameters: Encodable>(_ parameters: Parameters) -> DataRequest {
        return session.request(channelURL, method: .put, parameters: [parameters], encoder: JSONParameterEncoder(encoder: encoder)).validate().response { [weak self] response in
            self?.connectEventSourceIfDisconnected()
        }
    }
    
    @discardableResult public func scryRequest(app: String, path: String) -> DataRequest {
        return session.request(scryURL(app: app, path: path))
    }
    
}

extension Airlock {
    
    @discardableResult public func ackRequest(eventID: Int) -> DataRequest {
        let request = AckRequest(eventID: eventID)
        return channelRequest(request)
    }
    
    @discardableResult public func pokeRequest<JSON: Encodable>(ship: Ship, app: String, mark: String = "json", json: JSON, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let id = nextRequestID
        let ship = Ship.Prefixless(ship)
        let request = PokeRequest(id: id, ship: ship, app: app, mark: mark, json: json)
        pokeHandlers[id] = handler
        return channelRequest(request).response { [weak self] response in
            if response.error != nil {
                self?.pokeHandlers[id] = nil
            }
        }
    }
    
    @discardableResult public func subscribeRequest(ship: Ship, app: String, path: String, handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        let id = nextRequestID
        let ship = Ship.Prefixless(ship)
        let request = SubscribeRequest(id: id, ship: ship, app: app, path: path)
        subscribeHandlers[id] = handler
        return channelRequest(request).response { [weak self] response in
            if response.error != nil {
                self?.subscribeHandlers[id] = nil
            }
        }
    }
    
    @discardableResult public func subscribeRequest<JSON: Decodable>(ship: Ship, app: String, path: String, handler: @escaping (SubscribeEvent<JSON>) -> Void) -> DataRequest {
        let decoder = self.decoder
        return subscribeRequest(ship: ship, app: app, path: path) { event in
            handler(event.map { data in
                return try decoder.decode(JSON.self, from: data)
            })
        }
    }
    
    @discardableResult public func unsubscribeRequest(subscriptionID: Int) -> DataRequest {
        let id = nextRequestID
        let request = UnsubscribeRequest(id: id, subscriptionID: subscriptionID)
        return channelRequest(request)
    }
    
    @discardableResult public func deleteRequest() -> DataRequest {
        let request = DeleteRequest()
        return channelRequest(request)
    }
    
}

extension Airlock: EventSourceDelegate {
    
    public func eventSource(_ eventSource: EventSource, didReceiveMessage message: EventSourceMessage) {
        self.lastEventID = message.id
        
        guard let data = message.data?.data(using: .utf8) else {
            return
        }

        switch Result(catching: { try decoder.decode(Response.self, from: data) }) {
        case .success(.poke(let response)):
            switch response.result {
            case .okay:
                pokeHandlers[response.id]?(.finished)
                pokeHandlers[response.id] = nil
            case .error(let message):
                pokeHandlers[response.id]?(.failure(AirlockError.pokeFailure(message)))
                pokeHandlers[response.id] = nil
            }
        case .success(.subscribe(let response)):
            switch response.result {
            case .okay:
                subscribeHandlers[response.id]?(.started)
            case .error(let message):
                subscribeHandlers[response.id]?(.failure(AirlockError.subscribeFailure(message)))
                subscribeHandlers[response.id] = nil
            }
        case .success(.diff(let response)):
            subscribeHandlers[response.id]?(.update(response.json))
        case .success(.quit(let response)):
            subscribeHandlers[response.id]?(.finished)
            subscribeHandlers[response.id] = nil
        case .failure(let error):
            print("[Ursus] Error decoding message:", message, error)
        }
    }
    
    public func eventSource(_ eventSource: EventSource, didCompleteWithError error: EventSourceError) {
        pokeHandlers.values.forEach { handler in
            handler(.failure(error))
        }
        pokeHandlers.removeAll()
        
        subscribeHandlers.values.forEach { handler in
            handler(.failure(error))
        }
        subscribeHandlers.removeAll()
        
        resetEventSource()
    }
    
}

extension Airlock {
    
    private func connectEventSourceIfDisconnected() {
        guard eventSource == nil else {
            return
        }
        
        eventSource = EventSource(url: channelURL, delegate: self)
        eventSource?.connect(lastEventID: lastEventID)
    }
    
    private func resetEventSource() {
        eventSource = nil
        
        uid = Airlock.uid()
        
        requestID = 0
        lastEventID = nil
    }
    
}

extension Airlock {
    
    private var loginURL: URL {
        return credentials.url.appendingPathComponent("/~/login")
    }
    
    private var logoutURL: URL {
        return credentials.url.appendingPathComponent("/~/logout")
    }
    
    private var channelURL: URL {
        return credentials.url.appendingPathComponent("/~/channel/\(uid)")
    }
    
    private func scryURL(app: String, path: String) -> URL {
        return credentials.url.appendingPathComponent("/~/scry/\(app)\(path).json")
    }
    
}

extension Airlock {
    
    private static func uid() -> String {
        return "\(Int(Date().timeIntervalSince1970 * 1000))-\(String(Int.random(in: 0...0xFFFFFF), radix: 16))"
    }
    
}
