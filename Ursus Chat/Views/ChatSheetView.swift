//
//  ChatSheetView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 21/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatSheetView: View {
    
    enum Mode: Hashable, Identifiable {
        
        case new
        case join
        case directMessage
        
        var id: Int {
            return hashValue
        }
        
    }
    
    var mode: Mode
    
    var body: some View {
        switch mode {
        case .new:
            return AnyView(
                NewChatView()
            )
        case .join:
            return AnyView(
                JoinChatView()
            )
        case .directMessage:
            return AnyView(
                DirectMessageView()
            )
        }
    }
    
}
