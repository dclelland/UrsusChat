//
//  AppDelegate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 15/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import UIKit
import AlamofireLogger
import AlamofireNetworkActivityIndicator

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkActivityLogManager.shared.level = .verbose
        NetworkActivityIndicatorManager.shared.isEnabled = true
        appStore.dispatch(AppLaunchAction())
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        appStore.dispatch(AppTerminateAction())
    }

}
