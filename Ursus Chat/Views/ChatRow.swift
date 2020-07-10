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
        Text(envelope.letter.text)
    }
    
}
