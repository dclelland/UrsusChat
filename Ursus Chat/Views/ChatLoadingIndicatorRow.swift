//
//  ChatLoadingIndicatorRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 3/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatLoadingIndicatorRow: View {
    
    #warning("TODO: After iOS 14, swap for a ProgressView")
    
    var loading: Bool
    
    var body: some View {
        Text("Loading...")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
    
}
