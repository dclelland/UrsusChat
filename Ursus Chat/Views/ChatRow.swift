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
        HStack(alignment: .top, spacing: 8.0) {
            VStack(alignment: .leading) {
                SigilView(ship: envelope.author)
            }
            VStack(alignment: .leading, spacing: 8.0) {
                HStack(alignment: .firstTextBaseline, spacing: 8.0) {
                    Text(envelope.author.debugDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(envelope.formattedTime)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                LetterView(letter: envelope.letter)
            }
        }
        .padding(.bottom, 8.0)
    }
    
}
