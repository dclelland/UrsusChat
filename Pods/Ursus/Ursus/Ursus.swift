//
//  Ursus.swift
//  Ursus
//
//  Created by Daniel Clelland on 3/06/20.
//

import Foundation
import Alamofire

public typealias Ship = PatP

public typealias Code = PatP

public class Ursus {
    
    private var session: Session = .default
    private var eventSource: EventSource? = nil
    
    private var encoder = UrsusEncoder()
    private var decoder = UrsusDecoder()
    
    private var pokeHandlers = [Int: (PokeEvent) -> Void]()
    private var subscribeHandlers = [Int: (SubscribeEvent<Data>) -> Void]()
    
    private var uid: String = Ursus.uid()
    
    private var requestID: Int = 0
    private var nextRequestID: Int {
        requestID += 1
        return requestID
    }
    
    private var lastEventID: String? = nil
    
    public var url: URL
    public var code: Code
    
    public init(url: URL, code: Code) {
        self.url = url
        self.code = code
    }
    
    deinit {
        deleteRequest()
    }
    
}

extension Ursus {
    
    @discardableResult public func authenticationRequest(handler: @escaping (Ship) -> Void) -> DataRequest {
        return session.request(authenticationURL, method: .post, parameters: ["password": code.description], encoder: URLEncodedFormParameterEncoder.default).validate().response { response in
            guard let urbauth = response.response?.value(forHTTPHeaderField: "Set-Cookie") else {
                print("[Ursus] Error retrieving urbauth")
                return
            }
            
            guard let name = urbauth.split(separator: "=").first?.replacingOccurrences(of: "urbauth-", with: "") else {
                print("[Ursus] Error decoding urbauth:", urbauth)
                return
            }
            
            guard let ship = try? Ship(string: name) else {
                print("[Ursus] Error decoding urbauth:", urbauth)
                return
            }
            
            handler(ship)
        }
    }
    
    @discardableResult public func channelRequest<Parameters: Encodable>(_ parameters: Parameters) -> DataRequest {
        return session.request(channelURL, method: .put, parameters: [parameters], encoder: JSONParameterEncoder(encoder: encoder)).validate().response { [weak self] _ in
            self?.connectEventSourceIfDisconnected()
        }
    }
    
}

extension Ursus {
    
    @discardableResult public func ackRequest(eventID: Int) -> DataRequest {
        let request = AckRequest(eventID: eventID)
        return channelRequest(request)
    }
    
    @discardableResult public func pokeRequest<JSON: Encodable>(ship: Ship, app: String, mark: String = "json", json: JSON, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let id = nextRequestID
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

extension Ursus: EventSourceDelegate {
    
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
                pokeHandlers[response.id]?(.failure(PokeError.pokeFailure(message)))
                pokeHandlers[response.id] = nil
            }
        case .success(.subscribe(let response)):
            switch response.result {
            case .okay:
                subscribeHandlers[response.id]?(.started)
            case .error(let message):
                subscribeHandlers[response.id]?(.failure(SubscribeError.subscribeFailure(message)))
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

extension Ursus {
    
    private func connectEventSourceIfDisconnected() {
        guard eventSource == nil else {
            return
        }
        
        eventSource = EventSource(url: channelURL, delegate: self)
        eventSource?.connect(lastEventID: lastEventID)
    }
    
    private func resetEventSource() {
        eventSource = nil
        
        uid = Ursus.uid()
        
        requestID = 0
        lastEventID = nil
    }
    
}

extension Ursus {
    
    private var authenticationURL: URL {
        return url.appendingPathComponent("/~/login")
    }
    
    private var channelURL: URL {
        return url.appendingPathComponent("/~/channel/\(uid)")
    }
    
}

extension Ursus {
    
    private static func uid() -> String {
        return "\(Int(Date().timeIntervalSince1970 * 1000))-\(String(Int.random(in: 0...0xFFFFFF), radix: 16))"
    }
    
}
