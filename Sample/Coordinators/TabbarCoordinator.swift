//
//  TabbarCoordinator.swift
//  Sample
//
//  Created by Mads Kleemann on 13/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Foundation
import UIKit

class TabbarCoordinator: BaseCoordinator {
    
    typealias DependencyProvider = AppCoordinatorDependencyProvider & MoviesSearchCoordinatorDependencyProvider & MoviesDiscoverCoordinatorDependencyProvider
    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [BaseCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let tabbar = UITabBarController()
        
        let discoverCoordinator = MoviesDiscoverCoordinator(rootController: tabbar, dependencyProvider: dependencyProvider)
        discoverCoordinator.start()
        childCoordinators.append(discoverCoordinator)
        
        let searchCoordinator = MoviesSearchCoordinator(rootController: tabbar, dependencyProvider: dependencyProvider)
        searchCoordinator.start()
        childCoordinators.append(searchCoordinator)
        
        window.rootViewController = tabbar
    }
}


extension UITabBarController {
    func appendViewController(_ viewController: UIViewController, animated: Bool = false) {
        var vcs = viewControllers ?? []
        vcs.append(viewController)
        setViewControllers(vcs, animated: animated)
    }
}
