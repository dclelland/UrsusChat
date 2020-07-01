//
//  AppView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import Ursus

struct AppView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        switch store.state {
        case .login(let state):
            return AnyView(
                LoginView(state: state, handler: loginHandler)
            )
        case .chat(let state):
            return AnyView(
                TabView {
                    ChatView(state: state)
                    SettingsView()
                }
            )
        }
    }
    
}

extension AppView {
    
    private func loginHandler(url: URL, code: Code) {

        //let ursus = Ursus(url: url, code: code)
        //ursus.loginRequest { ship in
        //    ursus.chatView(ship: ship).primary { response in
        //        if let value = response.value {
        //            appStore.dispatch(AppAction.chat(.chatViewResponse(value)))
        //        }
        //    }
        //}.response { response in
        //    if let error = response.error {
        //        let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        //        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        //        self.window?.rootViewController?.present(alertController, animated: true)
        //    } else {
        //        self.window?.rootViewController = UIHostingController(rootView: AppView())
        //    }
        //}

        //ursus.authenticationRequest { ship in
        //    ursus.chatView(ship: ship).primary(handler: store.dispatch(_:)).response { response in
        //        ursus.chatHook(ship: ship).synced(handler: store.dispatch(_:))
        //        ursus.inviteStore(ship: ship).all(handler: store.dispatch(_:))
        //        ursus.permissionStore(ship: ship).all(handler: store.dispatch(_:))
        //        ursus.contactView(ship: ship).primary(handler: store.dispatch(_:))
        //        ursus.metadataStore(ship: ship).appName(app: "chat", handler: store.dispatch(_:))
        //        ursus.metadataStore(ship: ship).appName(app: "contacts", handler: store.dispatch(_:))
        //    }
        //}

    }
    
}

struct AppView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppView()
    }
    
}
