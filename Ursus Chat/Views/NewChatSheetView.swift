//
//  NewChatSheetView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 21/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct NewChatSheetView: View {
    
    enum Mode: Hashable, Identifiable {
        
        case groupChat
        case directMessage
        
        var id: Int {
            return hashValue
        }
        
    }
    
    var mode: Mode
    
    var body: some View {
        switch mode {
        case .groupChat:
            return AnyView(
                NewGroupChatView()
            )
        case .directMessage:
            return AnyView(
                NewDirectMessageView()
            )
        }
    }
    
}
