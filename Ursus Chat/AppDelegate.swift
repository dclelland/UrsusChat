//
//  AppDelegate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 15/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import UIKit
import ReSwift
import Ursus

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    let ursus = Ursus(url: URL(string: "http://192.168.1.65")!, code: "namwes-boster-dalryt-rosfeb")

    let store = Store<ChatState>(reducer: chatReducer, state: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let ursus = self.ursus
        
        ursus.authenticationRequest { ship in
            ursus.chatView(ship: ship).primary { event in
                print("[chat-view /primary]", event)
            }
            ursus.chatHook(ship: ship).synced { event in
                print("[chat-hook /synced]", event)
            }
            ursus.inviteView(ship: ship).primary { event in
                print("[invite-view /primary]", event)
            }
            ursus.permissionStore(ship: ship).all { event in
                print("[permission-store /all]", event)
            }
            ursus.contactView(ship: ship).primary { event in
                print("[contact-view /primary]", event)
            }
            ursus.metadataStore(ship: ship).appName(app: "chat") { event in
                print("[metadata-store /app-name/chat]", event)
            }
            ursus.metadataStore(ship: ship).appName(app: "contacts") { event in
                print("[metadata-store /app-name/contacts]", event)
            }
            ursus.s3Store(ship: ship).all { event in
                print("[s3-store /all]", event)
            }
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ursus.deleteRequest()
    }

}
