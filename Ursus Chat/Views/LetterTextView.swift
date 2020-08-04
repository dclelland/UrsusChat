//
//  LetterTextView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct LetterTextView: View {
    
    var text: LetterText
    
    var body: some View {
        Text(text)
            .font(.body)
            .foregroundColor(.primary)
    }
    
}
