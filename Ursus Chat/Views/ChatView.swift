//
//  ChatView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var store: AppStore
    
    var path: String
    
//    var mailbox: Mailbox
//
//    var metadata: Metadata? = nil
    
    var body: some View {
        Text(path)
//        List(mailbox.envelopes.reversed(), id: \.uid) { envelope in
//            ChatRow(state: envelope)
//        }
//        .navigationBarTitle(metadata?.title ?? "")
    }
    
}

struct ChatView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatView(path: "/~fipfes-fipfes/preview-chat")
            .environmentObject(AppStore.preview)
    }
    
}
