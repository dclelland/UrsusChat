//
//  PokeEvent.swift
//  Ursus
//
//  Created by Daniel Clelland on 10/06/20.
//

import Foundation

public enum PokeError: Error {
    
    case pokeFailure(String)
    
}

public enum PokeEvent {
    
    case finished
    case failure(PokeError)
    
}

extension PokeEvent {
    
    public var error: Error? {
        guard case .failure(let error) = self else {
            return nil
        }
        
        return error
    }
    
}
