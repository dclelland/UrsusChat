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

let ursus = Ursus(url: URL(string: "http://192.168.1.65")!, code: "figlec-lagbex-torrun-savmun")

let store = Store<ChatState>(reducer: chatReducer, state: nil, middleware: [chatLogger])

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ursus.authenticationRequest { ship in
            ursus.chatView(ship: ship).primary(handler: store.dispatch(_:)).response { response in
                ursus.chatHook(ship: ship).synced(handler: store.dispatch(_:))
                ursus.inviteStore(ship: ship).all(handler: store.dispatch(_:))
                ursus.permissionStore(ship: ship).all(handler: store.dispatch(_:))
                ursus.contactView(ship: ship).primary(handler: store.dispatch(_:))
                ursus.metadataStore(ship: ship).appName(app: "chat", handler: store.dispatch(_:))
                ursus.metadataStore(ship: ship).appName(app: "contacts", handler: store.dispatch(_:))
            }
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ursus.deleteRequest()
    }

}
