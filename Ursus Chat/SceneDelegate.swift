//
//  SceneDelegate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 15/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import UIKit
import SwiftUI
import Ursus

//ursus.authenticationRequest { ship in
//    ursus.chatView(ship: ship).primary(handler: store.dispatch(_:)).response { response in
//        ursus.chatHook(ship: ship).synced(handler: store.dispatch(_:))
//        ursus.inviteStore(ship: ship).all(handler: store.dispatch(_:))
//        ursus.permissionStore(ship: ship).all(handler: store.dispatch(_:))
//        ursus.contactView(ship: ship).primary(handler: store.dispatch(_:))
//        ursus.metadataStore(ship: ship).appName(app: "chat", handler: store.dispatch(_:))
//        ursus.metadataStore(ship: ship).appName(app: "contacts", handler: store.dispatch(_:))
//    }
//}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.tintColor = .systemIndigo
        self.window?.rootViewController = UIHostingController(
            rootView: LoginView(
                url: "http://192.168.1.78:8080",
                code: "lacnyd-morped-pilbel-pocnep",
                handler: { url, code in
                    let ursus = Ursus(url: url, code: code)
                    ursus.loginRequest { ship in
                        ursus.chatView(ship: ship).primary { response in
                            if let value = response.value {
                                appStore.dispatch(AppAction.chat(.chatViewResponse(value)))
                            }
                        }
                    }.response { response in
                        if let error = response.error {
                            let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default))
                            self.window?.rootViewController?.present(alertController, animated: true)
                        } else {
                            self.window?.rootViewController = UIHostingController(rootView: AppView())
                        }
                    }
                }
            )
        )
        self.window?.makeKeyAndVisible()
    }

}
