//
//  Airlock.swift
//  Ursus
//
//  Created by Daniel Clelland on 3/06/20.
//

import Foundation
import Alamofire

public class Airlock {
    
    private var session: Session = .default
    private var eventSource: EventSource? = nil
    
    private var encoder = AirlockJSONEncoder()
    private var decoder = AirlockJSONDecoder()
    
    private var pokeHandlers = [Int: (PokeEvent) -> Void]()
    private var subscribeHandlers = [Int: (SubscribeEvent<Data>) -> Void]()
    
    private var uid: String = Airlock.uid()
    
    private var requestID: Int = 0
    private var nextRequestID: Int {
        requestID += 1
        return requestID
    }
    
    private var lastEventID: Int = 0
    
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
    
    @discardableResult public func loginRequest(handler: @escaping (AFResult<Ship>) -> Void) -> DataRequest {
        let parameters = ["password": Code.Prefixless(credentials.code)]
        return session
            .request(loginURL, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .response(responseSerializer: AirlockLoginResponseSerializer()) { response in
                handler(response.result)
            }
    }
    
    @discardableResult public func logoutRequest() -> DataRequest {
        return session
            .request(logoutURL, method: .post)
            .validate()
    }
    
    @discardableResult public func channelRequest<Parameters: Encodable>(_ parameters: Parameters) -> DataRequest {
        let parameters = [parameters]
        return session
            .request(channelURL(uid: uid), method: .put, parameters: parameters, encoder: JSONParameterEncoder(encoder: encoder))
            .validate()
            .response { [weak self] response in
                self?.connectEventSourceIfDisconnected()
            }
    }
    
    @discardableResult public func scryRequest(app: App, path: Path) -> DataRequest {
        return session
            .request(scryURL(app: app, path: path))
    }
    
}

extension Airlock {
    
    @discardableResult public func ackRequest(eventID: Int) -> DataRequest {
        let request = AckRequest(eventID: eventID)
        return channelRequest(request)
    }
    
    @discardableResult public func pokeRequest<JSON: Encodable>(ship: Ship, app: App, mark: Mark = "json", json: JSON, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let id = nextRequestID
        let ship = Ship.Prefixless(ship)
        let request = PokeRequest(id: id, ship: ship, app: app, mark: mark, json: json)
        pokeHandlers[id] = handler
        return channelRequest(request).response { [weak self] response in
            if case .failure = response.result {
                self?.pokeHandlers[id] = nil
            }
        }
    }
    
    @discardableResult public func subscribeRequest(ship: Ship, app: App, path: Path, handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        let id = nextRequestID
        let ship = Ship.Prefixless(ship)
        let request = SubscribeRequest(id: id, ship: ship, app: app, path: path)
        subscribeHandlers[id] = handler
        return channelRequest(request).response { [weak self] response in
            if case .failure = response.result {
                self?.subscribeHandlers[id] = nil
            }
        }
    }
    
    @discardableResult public func subscribeRequest<JSON: Decodable>(ship: Ship, app: App, path: Path, handler: @escaping (SubscribeEvent<JSON>) -> Void) -> DataRequest {
        let decoder = self.decoder
        return subscribeRequest(ship: ship, app: app, path: path) { event in
            handler(event.tryMap { data in
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
        if let id = message.id.flatMap(Int.init) {
            lastEventID = id
            ackRequest(eventID: id)
        }
        
        if let data = message.data?.data(using: .utf8) {
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
        
        eventSource = EventSource(url: channelURL(uid: uid), delegate: self)
        eventSource?.connect(lastEventID: String(lastEventID))
    }
    
    private func resetEventSource() {
        eventSource = nil
        
        uid = Airlock.uid()
        
        requestID = 0
        lastEventID = 0
    }
    
}

extension Airlock {
    
    private var loginURL: URL {
        return credentials.url.appendingPathComponent("/~/login")
    }
    
    private var logoutURL: URL {
        return credentials.url.appendingPathComponent("/~/logout")
    }
    
    private func channelURL(uid: String) -> URL {
        return credentials.url.appendingPathComponent("/~/channel/\(uid)")
    }
    
    private func scryURL(app: App, path: Path) -> URL {
        return credentials.url.appendingPathComponent("/~/scry/\(app)\(path).json")
    }
    
}

extension Airlock {
    
    private static func uid() -> String {
        return "\(Int(Date().timeIntervalSince1970 * 1000))-\(String(Int.random(in: 0...0xFFFFFF), radix: 16))"
    }
    
}
