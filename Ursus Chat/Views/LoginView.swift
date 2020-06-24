//
//  LoginView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State private var url: URL?
    
    @State private var code: String?
    
    var body: some View {
        VStack {
            Text("Urbit URL")
            TextField("URL", value: $url, formatter: URLFormatter())
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView()
    }
    
}
