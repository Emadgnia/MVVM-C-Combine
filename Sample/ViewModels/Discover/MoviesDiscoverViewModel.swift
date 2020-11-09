//
//  MoviesDiscoverViewModel.swift
//  Sample
//
//  Created by Mads Kleemann on 13/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit
import Combine

final class MoviesDiscoverViewModel: MoviesDiscoverViewModelType {
    
    private var navigator: MoviesSearchNavigator?
    private let usageType: MoviesUsageType
    private var cancellables: [AnyCancellable] = []

    init(usageType: MoviesUsageType, navigator: MoviesSearchNavigator) {
        self.usageType = usageType
        self.navigator = navigator
    }
    
    func transform(input: MoviesDiscoverViewModelInput) -> MoviesDiscoverViewModelOuput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.selection
            .sink(receiveValue: { movieId in
                self.navigator?.showDetails(forMovie: movieId)
            })
            .store(in: &cancellables)

        return input.appear
            .flatMapLatest {
                self.usageType.discover()
        }
        .map({ result -> MoviesDiscoverState in
            switch result {
            case .success(let movies): return .success(self.viewModels(from: movies))
            case .failure(let error): return .failure(error)
            }
        })
        .eraseToAnyPublisher()
    }
    
    private func viewModels(from movies: [Movie]) -> [MovieViewModel] {
        return movies.map({[unowned self] movie in
            return MovieViewModelBuilder.viewModel(from: movie, imageLoader: {[unowned self] movie in self.usageType.loadImage(for: movie, size: .small) })
        })
    }
}
