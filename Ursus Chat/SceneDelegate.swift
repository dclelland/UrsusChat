//
//  SceneDelegate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 15/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.tintColor = UIColor(named: "Tint")
        self.window?.rootViewController = UIHostingController(rootView: AppView().environmentObject(AppStore.shared))
        self.window?.makeKeyAndVisible()
        
        AppStore.shared.dispatch(AppThunk.getCredentials())
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        AppStore.shared.dispatch(AppDisconnectAction())
    }

}
