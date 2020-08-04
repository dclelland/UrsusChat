//
//  LetterCodeView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct LetterCodeView: View {
    
    var code: LetterCode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(code.expression)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
            Divider()
            Text(code.output.joined().joined(separator: " "))
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
        }
    }
    
}
