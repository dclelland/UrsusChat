//
//  AppDelegate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 15/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import UIKit
import Ursus
import AlamofireLogger

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let ursus = Ursus(url: URL(string: "http://192.168.1.65")!, code: "namwes-boster-dalryt-rosfeb")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ursus.authenticationRequest().log(.verbose).response { response in
            guard let urbauth = response.response?.value(forHTTPHeaderField: "Set-Cookie") else {
                return
            }
            
            guard let ship = urbauth.replacingOccurrences(of: "urbauth-~", with: "").split(separator: "=").map(String.init).first else {
                return
            }
            
            self.ursus.chatView(ship: ship).primary(
                handler: { event in
                    switch event {
                    case .success:
                        print("Subscribe success")
                    case .message(let data):
                        print("Subscribe message:", try! UrsusDecoder().decode(ChatView.Primary.self, from: data))
                    case .failure(let error):
                        print("Subscribe failed:", error)
                    case .quit:
                        print("Subscribe quit")
                    }
                }
            ).log(.verbose)
        }
        
        return true
    }

}
