//
//  AppCoordinatorDependencyProvider.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit

/// The `AppCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the AppCoordinator
protocol AppCoordinatorDependencyProvider: class {
    /// Creates UIViewController
    func rootViewController() -> UINavigationController
}

protocol MoviesSearchCoordinatorDependencyProvider: class {
    /// Creates UIViewController to search for a movie
    func moviesSearchController(navigator: MoviesSearchNavigator) -> UIViewController

    // Creates UIViewController to show the details of the movie with specified identifier
    func movieDetailsController(_ movieId: Int) -> UIViewController
}
