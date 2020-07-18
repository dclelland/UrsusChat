//
//  ChatListView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import Introspect

struct ChatListView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var showingActionSheet = false
    
    var body: some View {
        NavigationView {
            List(store.state.subscription.inbox.sorted(by: \.value.when).reversed(), id: \.key) { (path, mailbox) in
                NavigationLink(destination: ChatView(path: path)) {
                    ChatListRow(path: path)
                }
            }
            .navigationBarTitle("Chats")
            .navigationBarItems(
                trailing: Button(action: openSigil) {
                    SigilView(ship: "~fipfes-fipfes", color: .white, size: CGSize(width: 24.0, height: 24.0))
//                    .padding(8.0)
//                    .background(Circle())
                }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(
                        title: Text("~fipfes-fipfes"),
                        buttons: [
                            .destructive(Text("Logout"), action: store[SessionLogoutAction()]),
                            .cancel()
                        ]
                    )
                }
            )
            .introspectTableView { tableView in
                tableView.tableFooterView = UIView()
            }
        }
    }
    
}

extension ChatListView {
    
    func openSigil() {
        showingActionSheet = true
    }
    
}
