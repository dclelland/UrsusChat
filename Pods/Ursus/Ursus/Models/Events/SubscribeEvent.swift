//
//  SubscribeEvent.swift
//  Ursus
//
//  Created by Daniel Clelland on 10/06/20.
//

import Foundation

public enum SubscribeEvent {
    
    case success
    case message(Data)
    case failure(SubscribeError)
    case quit
    
}
