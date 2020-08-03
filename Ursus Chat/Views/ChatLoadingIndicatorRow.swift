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
    
    #warning("TODO: Swap for ProgressView in iOS 14")
    
    var body: some View {
        Text("Loading Indicator Row: \(unloaded), \(loading ? "loading" : "ready")")
    }
    
}
