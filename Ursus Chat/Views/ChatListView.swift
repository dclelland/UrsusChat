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
    
    @State var selectedPath: String? = nil
    
    @State private var showingShipActionSheet = false
    
    @State private var showingChatActionSheet = false
    
    var ship: Ship
    
    var body: some View {
        NavigationView {
            List(store.state.subscription.inbox.sorted(by: \.value.when).reversed(), id: \.key) { (path, mailbox) in
                NavigationLink(destination: ChatView(path: path), tag: path, selection: self.$selectedPath) {
                    ChatListRow(path: path)
                }
            }
            .navigationBarTitle("Chats")
            .navigationBarItems(
                leading: Button(action: showShipActionSheet) {
                    SigilView(ship: ship)
                }
                .actionSheet(isPresented: $showingShipActionSheet) {
                    ActionSheet(
                        title: Text(ship.description),
                        buttons: [
                            .default(Text("Open Landscape"), action: openLandscape),
                            .destructive(Text("Logout"), action: logout),
                            .cancel()
                        ]
                    )
                },
                trailing: Button(action: showChatActionSheet) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                        .font(Font.title.weight(.light))
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
            )
            .introspectTableView { tableView in
                tableView.tableFooterView = UIView()
            }
        }
    }
    
}

extension ChatListView {
    
    func showShipActionSheet() {
        showingShipActionSheet = true
    }
    
    func showChatActionSheet() {
        showingChatActionSheet = true
    }
    
}

extension ChatListView {
    
    func openLandscape() {
        guard case .authenticated(let airlock, _) = store.state.session else {
            return
        }
        
        UIApplication.shared.open(airlock.credentials.url)
    }
    
    func logout() {
        store.dispatch(AppThunk.endSession())
    }
    
    func newChat() {
        
    }
    
    func joinChat() {
        
    }
    
    func directMessage() {
        
    }
    
}
