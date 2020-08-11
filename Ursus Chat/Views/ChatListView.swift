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
    
//    struct Destination: View {
//
//        var selectedPath: UrsusAirlock.Path? = nil
//
//        var body: some View {
//            if let path = selectedPath {
//                return AnyView(
//                    ChatView(path: path)
//                )
//            } else {
//                return AnyView(
//                    EmptyView()
//                )
//            }
//        }
//
//    }
    
    @EnvironmentObject var store: AppStore
    
    @State private var selectedPath: UrsusAirlock.Path? = nil
    
//    @State private var selectedPathIsActive: Bool = false
    
    @State private var selectedNewChatSheetViewMode: NewChatSheetView.Mode? = nil
    
    @State private var showingShipActionSheet = false
    
    @State private var showingNewChatActionSheet = false
    
    var ship: Ship
    
    #warning("TODO: Remove the clumsy ZStack hack in iOS 14 (https://stackoverflow.com/questions/61005551)")
    
    var body: some View {
        NavigationView {
//            ZStack {
//            NavigationLink(destination: Destination(selectedPath: selectedPath), isActive: $selectedPathIsActive) {
//                EmptyView()
//            }
            List {
                ConnectionView()
                ForEach(store.state.subscription.inbox.sorted(by: \.value.when).reversed(), id: \.key) { (path, mailbox) in
                    NavigationLink(destination: ChatView(path: path), tag: path, selection: self.$selectedPath) {
                        ChatListRow(path: path)
                    }
//                    Button(
//                        action: {
//                            self.selectedPath = path
//                            self.selectedPathIsActive = true
//                        },
//                        label: {
//                            NavigationLink(destination: EmptyView()) {
//                                ChatListRow(path: path)
//                            }
//                        }
//                    )
                }
            }
            .navigationBarTitle("Chats")
            .navigationBarItems(
                leading: Button(action: showShipActionSheet) {
                    SigilView(ship: ship)
                        .frame(width: 24.0, height: 24.0)
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
                trailing: Button(action: showNewChatActionSheet) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                        .font(Font.title.weight(.light))
                }
                .actionSheet(isPresented: $showingNewChatActionSheet) {
                    ActionSheet(
                        title: Text("Chats"),
                        buttons: [
                            .default(Text("New Group Chat"), action: showNewGroupChatView),
                            .default(Text("New Direct Message"), action: showNewDirectMessageView),
                            .cancel()
                        ]
                    )
                }
            )
            .listStyle(PlainListStyle())
            .introspectTableView { tableView in
                tableView.tableFooterView = UIView()
            }
//            }
        }
        .sheet(item: $selectedNewChatSheetViewMode) { mode in
            NewChatSheetView(mode: mode)
        }
    }
    
}

extension ChatListView {
    
    func showShipActionSheet() {
        showingShipActionSheet = true
    }
    
    func showNewChatActionSheet() {
        showingNewChatActionSheet = true
    }
    
    func showNewGroupChatView() {
        selectedNewChatSheetViewMode = .groupChat
    }
    
    func showNewDirectMessageView() {
        selectedNewChatSheetViewMode = .directMessage
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
        guard case .authenticated(let airlock, _) = store.state.session else {
            return
        }
        
        store.dispatch(AppThunk.stopSession(airlock: airlock))
    }
    
}
