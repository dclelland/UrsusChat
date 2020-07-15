//
//  ChatRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI
//import UrsusSigil

struct ChatRow: View {
    
    @EnvironmentObject var store: AppStore
    
    var envelope: Envelope
    
    var body: some View {
        HStack(alignment: .bottom) {
//            SigilView(ship: envelope.author)
//                .frame(width: 24.0, height: 24.0)
            Circle()
                .frame(width: 24.0, height: 24.0)
            VStack(alignment: .leading) {
                Text(envelope.author.debugDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                LetterView(letter: envelope.letter)
            }
            .padding(EdgeInsets(top: 4.0, leading: 8.0, bottom: 4.0, trailing: 8.0))
            .background(
                RoundedRectangle(cornerRadius: 9.0, style: .continuous)
                    .fill(Color(UIColor.systemGray4))
            )
        }
    }
    
}
