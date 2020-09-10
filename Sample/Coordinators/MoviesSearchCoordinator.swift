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
    fileprivate let rootController: UINavigationController
    fileprivate let dependencyProvider: MoviesSearchCoordinatorDependencyProvider

    init(rootController: UINavigationController, dependencyProvider: MoviesSearchCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchController = self.dependencyProvider.moviesSearchController(navigator: self)
        self.rootController.setViewControllers([searchController], animated: false)
    }

}

extension MoviesSearchCoordinator: MoviesSearchNavigator {

    func showDetails(forMovie movieId: Int) {
        let controller = self.dependencyProvider.movieDetailsController(movieId)
        self.rootController.pushViewController(controller, animated: true)
    }

}
