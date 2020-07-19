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
                Button(action: openURL) {
                    Text(url)
                        .font(.body)
                        .underline()
                }
                .buttonStyle(PlainButtonStyle())
            )
        case .code(let code):
            return AnyView(
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(code.expression)
                        .font(.system(.body, design: .monospaced))
                    Divider()
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

enum LetterViewError: Error {
    
    case invalidURL(String)
    
}

extension LetterView {
    
    func openURL() {
        guard case .url(let string) = letter else {
            return
        }
        
        guard let url = URL(string: string) else {
            store.dispatch(AppErrorAction(error: LetterViewError.invalidURL(string)))
            return
        }
        
        UIApplication.shared.open(url)
    }
    
}
