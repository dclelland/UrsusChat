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
            self.ursus.chatView(ship: "lapred-pandel-polnet-sorwed--bacbep-labmul-tolmes-marzod").primary(
                handler: { event in
                    switch event {
                    case .success:
                        print("Subscribe success")
                    case .message(let data):
                        print("Subscribe message:", try! JSONDecoder().decode(ChatView.Primary.self, from: data))
                    case .failure(let error):
                        print("Subscribe failed:", error)
                    case .quit:
                        print("Subscribe quit")
                    }
                }
            ).log(.verbose)
//            self.ursus.pokeRequest(
//                ship: "lapred-pandel-polnet-sorwed--bacbep-labmul-tolmes-marzod",
//                app: "chat-store",
//                mark: "json",
//                json: Message(
//                    path: "/~/~lapred-pandel-polnet-sorwed--bacbep-labmul-tolmes-marzod/mc",
//                    envelope: Envelope(
//                        number: 1,
//                        author: "~lapred-pandel-polnet-sorwed--bacbep-labmul-tolmes-marzod",
//                        letter: [
//                            "text": "hello world!"
//                        ]
//                    )
//                ),
//                handler: { event in
//                    print("Poke:", event)
//                }
//            ).log(.verbose)
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
