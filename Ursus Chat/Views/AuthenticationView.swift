//
//  AuthenticationView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import Ursus

struct AuthenticationView: View {
    
    @State var url: String = ""
    
    @State var code: String = ""
    
    var handler: (_ url: URL, _ code: Code) -> Void = { _, _ in }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Urbit URL")) {
                    TextField("sampel-palnet.arvo.network", text: $url)
                        .textContentType(.URL)
                        .autocapitalization(.none)
                }
                Section(header: Text("Access Key"), footer: Text("Get key from Bridge, or +code in dojo")) {
                    SecureField("sampel-ticlyt-migfun-falmel", text: $code)
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
            .navigationBarTitle("Authentication")
        }
    }
    
}

extension AuthenticationView {
    
    private func continueButtonTapped() {
        guard let url = URL(string: url), let code = try? Code(string: code) else {
            return
        }
        
        handler(url, code)
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
        AuthenticationView()
    }
    
}
