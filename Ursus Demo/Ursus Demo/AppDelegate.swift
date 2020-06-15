//
//  AppDelegate.swift
//  Ursus Demo
//
//  Created by Daniel Clelland on 3/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import UIKit
import Ursus
import AlamofireLogger

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let ursus = Ursus(url: URL(string: "http://192.168.1.65")!, code: "namwes-boster-dalryt-rosfeb")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ursus.authenticationRequest().log(.verbose).response { response in
            self.ursus.pokeRequest(
                ship: "lapred-pandel-polnet-sorwed--bacbep-labmul-tolmes-marzod",
                app: "chat-store",
                mark: "json",
                json: Message(
                    path: "/~/~lapred-pandel-polnet-sorwed--bacbep-labmul-tolmes-marzod/mc",
                    envelope: Envelope(
                        uid: UUID().base32String,
                        number: 1,
                        author: "~lapred-pandel-polnet-sorwed--bacbep-labmul-tolmes-marzod",
                        when: Int(Date().timeIntervalSince1970 * 1000),
                        letter: [
                            "text": "hello world!"
                        ]
                    )
                ),
                handler: { event in
                    print("Poke:", event)
                }
            ).log(.verbose)
//            self.ursus.subscribeRequest(
//                ship: "lapred-pandel-polnet-sorwed--bacbep-labmul-tolmes-marzod",
//                app: "chat-view",
//                path: "/primary",
//                handler: { event in
//                    switch event {
//                    case .success:
//                        print("Subscribe success")
//                    case .message(let data):
//                        print("Subscribe message:", String(data: data, encoding: .utf8)!)
//                    case .failure(let error):
//                        print("Subscribe failed:", error)
//                    case .quit:
//                        print("Subscribe quit")
//                    }
//                }
//            ).log(.verbose)
        }
        
        return true
    }

}

struct Message: Encodable {
    
    var path: String
    var envelope: Envelope
    
}

struct Envelope: Encodable {
    
    var uid: String
    var number: Int
    var author: String
    var when: Int
    var letter: [String: String]
    
}
