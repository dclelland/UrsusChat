//
//  PokeEvent.swift
//  Ursus
//
//  Created by Daniel Clelland on 10/06/20.
//

import Foundation

public enum PokeError: LocalizedError {
    
    case pokeFailure(String)
    
    public var errorDescription: String? {
        switch self {
        case .pokeFailure(let string):
            return "Poke failure: \(string)"
        }
    }
    
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
