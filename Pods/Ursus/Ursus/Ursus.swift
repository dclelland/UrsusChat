//
//  Ursus.swift
//  Ursus
//
//  Created by Daniel Clelland on 3/06/20.
//

import Foundation
import Alamofire

final public class Ursus {
    
    private var session: Session = .default
    private var eventSource: EventSource? = nil
    
    private var encoder = UrsusEncoder()
    private var decoder = UrsusDecoder()
    
    private var pokeHandlers = [Int: (PokeEvent) -> Void]()
    private var subscribeHandlers = [Int: (SubscribeEvent) -> Void]()
    
    private var uid: String = Ursus.uid()
    
    private var requestID: Int = 0
    private var nextRequestID: Int {
        requestID += 1
        return requestID
    }
    
    private var lastEventID: String? = nil
    
    public var url: URL
    public var code: String
    
    public init(url: URL, code: String) {
        self.url = url
        self.code = code
    }
    
    deinit {
        deleteRequest()
    }
    
}

extension Ursus {
    
    @discardableResult public func authenticationRequest() -> DataRequest {
        return session.request(authenticationURL, method: .post, parameters: ["password": code], encoder: URLEncodedFormParameterEncoder.default).validate()
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
    
    @discardableResult public func pokeRequest<JSON: Encodable>(ship: String, app: String, mark: String = "json", json: JSON, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let id = nextRequestID
        let request = PokeRequest(id: id, ship: ship, app: app, mark: mark, json: json)
        pokeHandlers[id] = handler
        return channelRequest(request).response { [weak self] response in
            if let error = response.error {
                self?.pokeHandlers[id]?(.failure(error))
                self?.pokeHandlers[id] = nil
            }
        }
    }
    
    @discardableResult public func subscribeRequest(ship: String, app: String, path: String, handler: @escaping (SubscribeEvent) -> Void) -> DataRequest {
        let id = nextRequestID
        let request = SubscribeRequest(id: id, ship: ship, app: app, path: path)
        subscribeHandlers[id] = handler
        return channelRequest(request).response { [weak self] response in
            if let error = response.error {
                self?.subscribeHandlers[id]?(.failure(error))
                self?.subscribeHandlers[id] = nil
            }
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

extension Ursus {
    
    private static func uid() -> String {
        return "\(Int(Date().timeIntervalSince1970 * 1000))-\(String(Int.random(in: 0...0xFFFFFF), radix: 16))"
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

extension Ursus: EventSourceDelegate {
    
    public func eventSource(_ eventSource: EventSource, didReceiveMessage message: EventSourceMessage) {
        self.lastEventID = message.id
        
        guard let data = message.data?.data(using: .utf8) else {
            return
        }

        switch Result(catching: { try decoder.decode(Response.self, from: data) }) {
        case .success(let response):
            switch response {
            case .poke(let response):
                switch response.result {
                case .success:
                    pokeHandlers[response.id]?(.success)
                    pokeHandlers[response.id] = nil
                case .failure(let error):
                    pokeHandlers[response.id]?(.failure(error))
                    pokeHandlers[response.id] = nil
                }
            case .subscribe(let response):
                switch response.result {
                case .success:
                    subscribeHandlers[response.id]?(.success)
                case .failure(let error):
                    subscribeHandlers[response.id]?(.failure(error))
                    subscribeHandlers[response.id] = nil
                }
            case .diff(let response):
                subscribeHandlers[response.id]?(.message(response.json))
            case .quit(let response):
                subscribeHandlers[response.id]?(.quit)
                subscribeHandlers[response.id] = nil
            }
        case .failure(let error):
            print("[Ursus] Error decoding message:", message, error)
        }
    }
    
    public func eventSource(_ eventSource: EventSource, didCompleteWithError error: EventSourceError) {
        pokeHandlers.values.forEach { handler in
            handler(.failure(error))
        }
        subscribeHandlers.values.forEach { handler in
            handler(.failure(error))
        }
            
        pokeHandlers.removeAll()
        subscribeHandlers.removeAll()
        
        resetEventSource()
    }
    
}
