//
//  ChatLoadingIndicatorRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 3/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatLoadingIndicatorRow: View {
    
    var unloaded: Int
    
    var loading: Bool
    
    #warning("TODO: Render loading state")
    
    var body: some View {
        Text("Loading Indicator Row: \(unloaded), \(loading ? "loading" : "ready")")
    }
    
}
