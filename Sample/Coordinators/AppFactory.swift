//
//  AppFactory.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit

/// The AppFactory takes responsibity of creating application components and establishing dependencies between them.
final class AppFactory {
    fileprivate lazy var usageType: MoviesUsageType = MoviesUsageType(networkService: networkProvider.network,
                                                                      imageLoaderService: networkProvider.imageLoader)

    private let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider = NetworkProvider.defaultProvider()) {
        self.networkProvider = networkProvider
    }
}

extension AppFactory: AppCoordinatorDependencyProvider {

    func rootViewController() -> UINavigationController {
        let rootViewController = UINavigationController()
        rootViewController.navigationBar.tintColor = UIColor.black
        return rootViewController
    }
}

extension AppFactory: MoviesSearchCoordinatorDependencyProvider {

    func moviesSearchController(navigator: MoviesSearchNavigator) -> UIViewController {
        let viewModel = MoviesSearchViewModel(usageType: usageType, navigator: navigator)
        return MoviesSearchViewController(viewModel: viewModel)
    }

    func movieDetailsController(_ movieId: Int) -> UIViewController {
        let viewModel = MovieDetailsViewModel(movieId: movieId, usageType: usageType)
        return MovieDetailsViewController(viewModel: viewModel)
    }
}


extension AppFactory: MoviesDiscoverCoordinatorDependencyProvider {
    
    func makeDiscoverViewController(navigator: MoviesSearchNavigator) -> UIViewController {
        return MoviesDiscoverViewController(viewModel: MoviesDiscoverViewModel(usageType: usageType, navigator: navigator))
    }
}
