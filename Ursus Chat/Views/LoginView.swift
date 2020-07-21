//
//  LoginView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
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
                Section(header: Text("URL"), footer: Text("The URL where your ship is hosted")) {
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
                    Button(action: startSession) {
                        Text("Continue")
                    }
                    Button(action: openBridge) {
                        Text("Open Bridge")
                    }
                    Button(action: openPurchaseID) {
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

enum LoginViewError: LocalizedError {
    
    case invalidURL(String)
    case invalidCode(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \"\(url)\""
        case .invalidCode:
            return "Invalid Access Key"
        }
    }
    
}

extension LoginView {
    
    private func startSession() {
        guard let url = URL(string: url) else {
            store.dispatch(AppErrorAction(error: LoginViewError.invalidURL(self.url)))
            return
        }
        
        guard let code = try? Code(string: code) else {
            store.dispatch(AppErrorAction(error: LoginViewError.invalidCode(self.code)))
            return
        }
        
        store.dispatch(AppThunk.startSession(credentials: AirlockCredentials(url: url, code: code)))
    }
    
    private func openBridge() {
        UIApplication.shared.open(.bridgeURL)
    }
    
    private func openPurchaseID() {
        UIApplication.shared.open(.purchaseIDURL)
    }
    
}

extension URL {
    
    static let bridgeURL = URL(string: "https://bridge.urbit.org/")!
    
    static let purchaseIDURL = URL(string: "https://urbit.org/using/install/#id")!
    
}
