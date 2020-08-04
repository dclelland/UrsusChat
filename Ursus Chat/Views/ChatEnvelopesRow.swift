//
//  ChatEnvelopesRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 3/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import NonEmpty

struct ChatEnvelopesRowModel: Hashable {
    
    enum State {
        
        case pending
        case sent
        
    }
    
    var envelope: Envelope
    var state: State
    
}

struct ChatEnvelopesRow: View {
    
    var viewModel: NonEmpty<[ChatEnvelopesRowModel]>
    
    var body: some View {
        HStack(alignment: .top, spacing: 16.0) {
            VStack(alignment: .leading) {
                SigilView(ship: viewModel.head.envelope.author)
                    .frame(width: 24.0, height: 24.0)
            }
            VStack(alignment: .leading, spacing: 8.0) {
                HStack(alignment: .firstTextBaseline, spacing: 8.0) {
                    Text(viewModel.head.envelope.author.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(viewModel.head.envelope.formattedTime)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                ForEach(viewModel, id: \.envelope.uid) { envelope in
                    LetterView(letter: envelope.envelope.letter)
                        .opacity(envelope.state == .pending ? 0.5 : 1.0)
                }
            }
            .padding(EdgeInsets(top: 2.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
        }
    }
    
}
