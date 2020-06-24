//
//  SubscribeEvent.swift
//  Ursus
//
//  Created by Daniel Clelland on 10/06/20.
//

import Foundation

public enum SubscribeEvent<Value> {

    case started
    case update(Value)
    case finished
    case failure(Error)

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
    
    public func map<NewValue>(_ transform: (Value) throws -> NewValue) -> SubscribeEvent<NewValue> {
        switch self {
        case .started:
            return .started
        case .update(let value):
            do {
                return .update(try transform(value))
            } catch let error {
                return .failure(error)
            }
        case .finished:
            return .finished
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
