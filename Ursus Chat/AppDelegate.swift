//
//  AppDelegate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 15/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import UIKit
import Ursus

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    let ursus = Ursus(url: URL(string: "http://192.168.1.65")!, code: "namwes-boster-dalryt-rosfeb")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let ursus = self.ursus
        
        ursus.authenticationRequest { ship in
            ursus.chatView(ship: ship).primary { event in
                print("Primary event:", event)
            }
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ursus.deleteRequest()
    }

}
