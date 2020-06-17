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
    
    public func map<T>(_ transform: (Value) throws -> T) -> SubscribeEvent<T> {
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
