//
//  ChatReadIndicatorRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 3/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatReadIndicatorRow: View {
    
    var unread: Int
    
    var body: some View {
        Text("\(unread) Unread Messages")
            .font(.subheadline)
            .foregroundColor(Color(UIColor.systemBackground))
            .padding(.vertical, 2.0)
            .padding(.horizontal, 8.0)
            .background(
                RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                    .fill(Color(UIColor.systemGray2))
            )
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
}

