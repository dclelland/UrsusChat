//
//  ChatRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatRow: View {
    
    var state: Envelope
    
    var body: some View {
        Text(state.uid)
    }
    
}

struct ChatRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatRow(
            state: Envelope(
                uid: "0",
                number: 0,
                author: "author",
                when: Date(),
                letter: .text("Hello")
            )
        )
    }
    
}

