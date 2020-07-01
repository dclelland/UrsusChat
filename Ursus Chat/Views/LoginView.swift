//
//  LoginView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import Ursus

struct LoginView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State var state: LoginState
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Urbit URL")) {
                    TextField("sampel-palnet.arvo.network", text: $state.url)
                        .textContentType(.URL)
                        .autocapitalization(.none)
                }
                Section(header: Text("Access Key"), footer: Text("Get key from Bridge, or +code in dojo")) {
                    SecureField("sampel-ticlyt-migfun-falmel", text: $state.code)
                }
                Section {
                    Button(action: continueButtonTapped) {
                        Text("Continue")
                    }
                    Button(action: bridgeButtonTapped) {
                        Text("Open Bridge")
                    }
                    Button(action: purchaseButtonTapped) {
                        Text("Purchase an Urbit ID")
                    }
                }
            }
            .navigationBarTitle("Login")
        }
    }
    
}

extension LoginView {
    
    private func continueButtonTapped() {
        guard let url = URL(string: state.url), let code = try? Code(string: state.code) else {
            return
        }
        

        let ursus = Ursus(url: url, code: code)
        ursus.loginRequest { ship in
            ursus.chatView(ship: ship).primary { response in
                if let value = response.value {
                    appStore.dispatch(AppAction.chat(.chatViewResponse(value)))
                }
            }
        }.response { response in
            if let error = response.error {
//                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: .default))
//                self.window?.rootViewController?.present(alertController, animated: true)
            } else {
                store.dispatch(<#T##action: Action##Action#>)
        //                self.window?.rootViewController = UIHostingController(rootView: AppView())
                    }
                }

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
    
    private func bridgeButtonTapped() {
        UIApplication.shared.open(URL(string: "https://bridge.urbit.org/")!)
    }
    
    private func purchaseButtonTapped() {
        UIApplication.shared.open(URL(string: "https://urbit.org/using/install/#id")!)
    }
    
}

struct AuthenticationView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView(state: LoginState())
    }
    
}
