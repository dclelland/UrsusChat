//
//  SubscribeEvent.swift
//  Ursus
//
//  Created by Daniel Clelland on 10/06/20.
//

import Foundation

public enum SubscribeError: LocalizedError {
    
    case subscribeFailure(String)
    
    public var errorDescription: String? {
        switch self {
        case .subscribeFailure(let string):
            return "Subscribe failure: \(string)"
        }
    }
    
}

public enum SubscribeEvent<Value> {

    case started
    case update(Value)
    case finished
    case failure(SubscribeError)

}

extension SubscribeEvent {
    
    public var value: Value? {
        guard case .update(let value) = self else {
            return nil
        }
        
        return value
    }
    
    public var error: Error? {
        guard case .failure(let error) = self else {
            return nil
        }
        
        return error
    }
    
}

extension SubscribeEvent {
    
    internal func map<NewValue>(_ transform: (Value) -> NewValue) -> SubscribeEvent<NewValue> {
        switch self {
        case .started:
            return .started
        case .update(let value):
            return .update(transform(value))
        case .finished:
            return .finished
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
