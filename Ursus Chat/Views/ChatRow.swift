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
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 8.0) {
                SigilView(ship: envelope.author)
                Text(envelope.author.debugDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            HStack(alignment: .top, spacing: 8.0) {
                Spacer()
                    .frame(width: 24.0)
                LetterView(letter: envelope.letter)
            }
        }
    }
    
}
