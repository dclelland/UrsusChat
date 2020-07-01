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
    
    @EnvironmentObject var store: AppStore
    
    var name: String
    
    var mailbox: ChatStoreApp.Mailbox
    
    var body: some View {
        Text(name)
    }
    
}

struct ChatListRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatListRow(name: "name", mailbox: ChatStoreApp.Mailbox(config: ChatStoreApp.Config(length: 0, read: 0), envelopes: []))
    }
    
}
