//
//  ChatStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk

let chatStore = Store<ChatState>(reducer: chatReducer, state: nil, middleware: [createLoggerMiddleware(), createThunkMiddleware()])
