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
                LetterTextView(text: text)
            )
        case .url(let url):
            return AnyView(
                LetterURLView(url: url)
            )
        case .code(let code):
            return AnyView(
                LetterCodeView(code: code)
            )
        case .me(let me):
            return AnyView(
                LetterMeView(me: me)
            )
        }
    }
    
}
