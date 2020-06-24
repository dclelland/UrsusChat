//
//  ChatMiddleware.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

let chatLogger: Middleware<ChatState> = { dispatch, getState in
    return { next in
        return { action in
            print("> \(action)")
            next(action)
        }
    }
}
