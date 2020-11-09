//
//  MoviesSearchCoordinator.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit

/// The `MoviesSearchCoordinator` takes control over the s on the movies search screen
class MoviesSearchCoordinator: BaseCoordinator {
    fileprivate let rootController: UITabBarController
    fileprivate var rootNavigationController: UINavigationController
    fileprivate let dependencyProvider: MoviesSearchCoordinatorDependencyProvider

    init(rootController: UITabBarController, dependencyProvider: MoviesSearchCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
        self.rootNavigationController = UINavigationController()
    }

    func start() {
        let searchController = self.dependencyProvider.moviesSearchController(navigator: self)
        rootNavigationController.setViewControllers([searchController], animated: false)
        rootNavigationController.navigationBar.tintColor = UIColor.black
        
        self.rootController.appendViewController(rootNavigationController)
    }
}

extension MoviesSearchCoordinator: MoviesSearchNavigator {

    func showDetails(forMovie movieId: Int) {
        let controller = self.dependencyProvider.movieDetailsController(movieId)
        self.rootNavigationController.pushViewController(controller, animated: true)
    }

}
