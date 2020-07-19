//
//  LetterURLView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 19/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI

struct LetterURLView: View {
    
    @EnvironmentObject var store: AppStore
    
    var url: LetterURL
    
    var body: some View {
        Button(action: openURL) {
            Text(url)
                .font(.body)
                .foregroundColor(.primary)
                .underline()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

enum LetterURLViewError: LocalizedError {
    
    case invalidURL(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \"\(url)\""
        }
    }
    
}

extension LetterURLView {
    
    func openURL() {
        guard let url = URL(string: url) else {
            store.dispatch(AppErrorAction(error: LetterURLViewError.invalidURL(self.url)))
            return
        }
        
        UIApplication.shared.open(url)
    }
    
}
