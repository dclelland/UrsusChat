//
//  ChatListRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatListRow: View {
    
    struct ViewModel {
        
        var title: String
        var subtitle: String
        var author: String
        var date: String
        var unread: String?
        
    }
    
    @EnvironmentObject var store: AppStore
    
    var path: String
    
    var model: ViewModel {
        return ViewModel(
            title: "Title",
            subtitle: "Subtitle",
            author: "~fipfes-fipfes",
            date: "1/1/20",
            unread: "1"
        )
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(model.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(model.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            VStack(alignment: .trailing) {
                Text(model.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(model.unread ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
}

struct ChatListRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListRow(path: "/~fipfes-fipfes/preview-chat")
            .environmentObject(AppStore.preview)
            .previewLayout(.sizeThatFits)
    }
    
}
