//
//  MoviesDiscoverCoordinator.swift
//  Sample
//
//  Created by Mads Kleemann on 13/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Foundation
import UIKit

class MoviesDiscoverCoordinator: BaseCoordinator {
    
    fileprivate let rootTabBarController: UITabBarController
    fileprivate var rootNavigationController: UINavigationController
    fileprivate let dependencyProvider: MoviesDiscoverCoordinatorDependencyProvider & MoviesSearchCoordinatorDependencyProvider
    fileprivate var detailsViewController: UIViewController?
    
    init(rootController: UITabBarController, dependencyProvider: MoviesDiscoverCoordinatorDependencyProvider & MoviesSearchCoordinatorDependencyProvider) {
        self.rootTabBarController = rootController
        self.dependencyProvider = dependencyProvider
        self.rootNavigationController = UINavigationController()
    }
    
    func start() {
        rootNavigationController = UINavigationController()
        let vc = dependencyProvider.makeDiscoverViewController(navigator: self)
        
        rootNavigationController.setViewControllers([vc], animated: false)
        self.rootTabBarController.appendViewController(rootNavigationController)
    }
    
}


extension MoviesDiscoverCoordinator: MoviesSearchNavigator {

    func showDetails(forMovie movieId: Int) {
        detailsViewController = self.dependencyProvider.movieDetailsController(movieId)
        self.rootNavigationController.pushViewController(detailsViewController!, animated: true)
    }

}
