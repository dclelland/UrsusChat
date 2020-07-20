//
//  ChatRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI
import NonEmpty

struct ChatRow: View {
    
    @EnvironmentObject var store: AppStore
    
    var envelopes: NonEmpty<[Envelope]>
    
    var body: some View {
        HStack(alignment: .top, spacing: 16.0) {
            VStack(alignment: .leading) {
                SigilView(ship: envelopes.head.author)
            }
            VStack(alignment: .leading, spacing: 8.0) {
                HStack(alignment: .firstTextBaseline, spacing: 8.0) {
                    Text(envelopes.head.author.debugDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(envelopes.head.formattedTime)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                ForEach(envelopes, id: \.uid) { envelope in
                    LetterView(letter: envelope.letter)
                }
            }
            .padding(EdgeInsets(top: 2.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
        }
    }
    
}
