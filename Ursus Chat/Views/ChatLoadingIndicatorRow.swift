//
//  ChatLoadingIndicatorRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 3/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatLoadingIndicatorRow: View {
    
    var loading: Bool
    
    var body: some View {
        Text("Loading...")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
}
