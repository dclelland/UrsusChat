//
//  LetterMeView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct LetterMeView: View {
    
    var me: LetterMe
    
    var body: some View {
        Text(me)
            .font(.body)
            .foregroundColor(.primary)
            .italic()
    }
    
}
