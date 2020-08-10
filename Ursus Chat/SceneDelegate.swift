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
    
    var store: AppStore = .shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        store.dispatch(AppThunk.getCredentials())
        
        window = UIWindow(windowScene: windowScene)
        window?.tintColor = UIColor(named: "Tint")
        window?.rootViewController = UIHostingController(rootView: AppView().environmentObject(store))
        window?.makeKeyAndVisible()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            guard case .authenticated(let airlock, let ship) = self.store.state.session, case .disconnected = self.store.state.connection else {
                return
            }
            
            self.store.dispatch(AppThunk.startSubscription(airlock: airlock, ship: ship))
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        store.dispatch(AppDisconnectAction())
    }

}
