//
//  ConnectionView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 8/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ConnectionView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        switch store.state.connection {
        case .ready, .connecting, .connected:
            return AnyView(
                EmptyView()
            )
        case .reconnecting:
            return AnyView(
                Text("Reconnecting...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            )
        case .disconnected:
            return AnyView(
                Button(action: reconnect) {
                    Text("Reconnect ↻")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(PlainButtonStyle())
            )
        }
    }

}

extension ConnectionView {
    
    func reconnect() {
        guard case .authenticated(let airlock, let ship) = store.state.session else {
            return
        }

        store.dispatch(AppThunk.startSubscription(airlock: airlock, ship: ship))
    }
    
}
