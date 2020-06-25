//
//  AuthenticationView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State private var url: URL?
    
    @State private var code: String = ""
    
    var body: some View {
        VStack() {
            Text("Urbit URL")
            TextField("http://sampel-palnet.arvo.network", value: $url, formatter: URLFormatter())
            Text("Access Key")
            Text("Get key from Bridge, or +code in dojo")
                .font(.caption)
            SecureField("sampel-ticlyt-migfun-falmel", text: $code) // Monospaced; password
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
    
}

extension AuthenticationView {
    
    private func continueButtonTapped() {
        
    }
    
    private func bridgeButtonTapped() {
        
    }
    
    private func purchaseButtonTapped() {
        
    }
    
}

struct AuthenticationView_Previews: PreviewProvider {
    
    static var previews: some View {
        AuthenticationView()
    }
    
}
