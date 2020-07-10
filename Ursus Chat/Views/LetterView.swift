//
//  LetterView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 10/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI

struct LetterView: View {
    
    @EnvironmentObject var store: AppStore
    
    var letter: Letter
    
    var body: some View {
        switch letter {
        case .text(let text):
            return AnyView(
                Text(text)
                    .font(.body)
            )
        case .url(let url):
            return AnyView(
                Text(url)
                    .font(.body)
                    .underline()
            )
        case .code(let code):
            return AnyView(
                VStack {
                    Text(code.expression)
                        .font(.system(.body, design: .monospaced))
                    Text(code.output.joined().joined(separator: " "))
                        .font(.system(.body, design: .monospaced))
                }
            )
        case .me(let me):
            return AnyView(
                Text(me)
                    .font(.body)
                    .italic()
            )
        }
    }
    
}
