//
//  SceneDelegate.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.appCoordinator = AppCoordinator(window: window, dependencyProvider: AppFactory())
        self.appCoordinator.start()

        self.window = window
        self.window?.makeKeyAndVisible()

    }



}

