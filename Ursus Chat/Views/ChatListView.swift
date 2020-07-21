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

struct SheetView<Content: View>: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let viewBuilder: () -> Content
    
    var body: some View {
        NavigationView {
            viewBuilder()
            .navigationBarItems(
                trailing: Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Dismiss")
                    }
                )
            )
        }
    }
}

struct ChatListView: View {
    
    private enum Sheet: Hashable, Identifiable, View {
        
        case newChat
        case joinChat
        case directMessage
        
        var id: Int {
            return hashValue
        }
        
        var body: some View {
            switch self {
            case .newChat:
                return SheetView {
                    Text("New Chat")
                    .navigationBarTitle("New Chat")
                }
            case .joinChat:
                return SheetView {
                    Text("Join Chat")
                    .navigationBarTitle("Join Chat")
                }
            case .directMessage:
                return SheetView {
                    Text("Direct Message")
                    .navigationBarTitle("Direct Message")
                }
            }
        }
        
    }
    
    @EnvironmentObject var store: AppStore
    
    @State private var selectedPath: String? = nil
    
    @State private var selectedSheet: Sheet? = nil
    
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
                            .default(Text("New Chat"), action: showNewChatView),
                            .default(Text("Join Chat"), action: showJoinChatView),
                            .default(Text("Direct Message"), action: showDirectMessageView),
                            .cancel()
                        ]
                    )
                }
            )
            .introspectTableView { tableView in
                tableView.tableFooterView = UIView()
            }
        }
        .sheet(item: $selectedSheet) { sheet in
            sheet
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
    
    func showNewChatView() {
        selectedSheet = .newChat
    }
    
    func showJoinChatView() {
        selectedSheet = .joinChat
    }
    
    func showDirectMessageView() {
        selectedSheet = .directMessage
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
    
}
