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
    
    @EnvironmentObject var store: AppStore
    
    var envelope: Envelope
    
    var body: some View {
        Text(envelope.letter.text)
    }
    
}

struct ChatRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatRow(
            envelope: Envelope(
                uid: "0",
                number: 0,
                author: "~fipfes-fipfes",
                when: Date(),
                letter: .text("Hello")
            )
        )
        .previewLayout(.sizeThatFits)
        .environmentObject(AppStore.preview)
    }
    
}

