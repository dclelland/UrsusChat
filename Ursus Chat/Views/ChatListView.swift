//
//  ChatListView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import Introspect
import UrsusAirlock
import UrsusSigil

struct ChatListView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var showingChatActionSheet = false
    
    @State private var showingShipActionSheet = false
    
    var ship: Ship
    
    var body: some View {
        NavigationView {
            List(store.state.subscription.inbox.sorted(by: \.value.when).reversed(), id: \.key) { (path, mailbox) in
                NavigationLink(destination: ChatView(path: path)) {
                    ChatListRow(path: path)
                }
            }
            .navigationBarTitle("Chats")
            .navigationBarItems(
                trailing: HStack(spacing: 8.0) {
                    Button(action: showChatActionSheet) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 24.0, height: 24.0)
                    }
                    .actionSheet(isPresented: $showingChatActionSheet) {
                        ActionSheet(
                            title: Text("Chats"),
                            buttons: [
                                .default(Text("New Chat"), action: newChat),
                                .default(Text("Join Chat"), action: joinChat),
                                .default(Text("Direct Message"), action: directMessage),
                                .cancel()
                            ]
                        )
                    }
                    Button(action: showShipActionSheet) {
                        SigilView(ship: ship)
                    }
                    .actionSheet(isPresented: $showingShipActionSheet) {
                        ActionSheet(
                            title: Text(ship.debugDescription),
                            buttons: [
                                .default(Text("Open Landscape"), action: openLandscape),
                                .destructive(Text("Logout"), action: logout),
                                .cancel()
                            ]
                        )
                    }
                }
            )
            .introspectTableView { tableView in
                tableView.tableFooterView = UIView()
            }
        }
    }
    
}

extension ChatListView {
    
    func showChatActionSheet() {
        showingChatActionSheet = true
    }
    
    func showShipActionSheet() {
        showingShipActionSheet = true
    }
    
}

extension ChatListView {
    
    func newChat() {
        
    }
    
    func joinChat() {
        
    }
    
    func directMessage() {
        
    }
    
    func openLandscape() {
        guard case .authenticated(let airlock, _) = store.state.session else {
            return
        }
        
        UIApplication.shared.open(airlock.credentials.url)
    }
    
    func logout() {
        store.dispatch(AppThunk.endSession())
    }
    
}
