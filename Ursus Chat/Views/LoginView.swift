//
//  LoginView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import Combine
import KeyboardObserving
import UrsusAirlock

struct LoginView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State var url: String = ""
    
    @State var code: String = ""
    
    var isAuthenticating: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Urbit URL"), footer: Text("The URL where your ship is hosted")) {
                    TextField("http://sampel-palnet.arvo.network", text: $url)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                Section(header: Text("Access Key"), footer: Text("Get key from Bridge, or +code in dojo")) {
                    SecureField("sampel-ticlyt-migfun-falmel", text: $code)
                        .textContentType(.password)
                        .keyboardType(.asciiCapable)
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
            .disabled(isAuthenticating)
            .navigationBarTitle("Login")
            .keyboardObserving()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

extension LoginView {
    
    private func continueButtonTapped() {
        guard let url = URL(string: url), let code = try? Code(string: code) else {
            return
        }
        
        store.dispatch(AppThunk.startSession(credentials: AirlockCredentials(url: url, code: code)))
    }
    
    private func bridgeButtonTapped() {
        UIApplication.shared.open(URL(string: "https://bridge.urbit.org/")!)
    }
    
    private func purchaseButtonTapped() {
        UIApplication.shared.open(URL(string: "https://urbit.org/using/install/#id")!)
    }
    
}
