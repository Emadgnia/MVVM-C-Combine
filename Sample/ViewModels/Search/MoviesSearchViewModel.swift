//
//  MoviesSearchViewModel.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit
import Combine

protocol MoviesSearchNavigator: AnyObject {
    /// Presents the movies details screen
    func showDetails(forMovie movieId: Int)
}

final class MoviesSearchViewModel: MoviesSearchViewModelType {

    private weak var navigator: MoviesSearchNavigator?
    private let usageType: MoviesUsageType
    private var cancellables: [AnyCancellable] = []

    init(usageType: MoviesUsageType, navigator: MoviesSearchNavigator) {
        self.usageType = usageType
        self.navigator = navigator
    }

    func transform(input: MoviesSearchViewModelInput) -> MoviesSearchViewModelOuput {

        input.selection
            .sink(receiveValue: { [unowned self] movieId in self.navigator?.showDetails(forMovie: movieId) })
            .store(in: &cancellables)

        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .removeDuplicates()
        let movies = searchInput
            .filter({ !$0.isEmpty })
            .flatMapLatest({[unowned self] query in self.usageType.searchMovies(with: query) })
            .map({ result -> MoviesSearchState in
                switch result {
                    case .success([]): return .noResults
                    case .success(let movies): return .success(self.viewModels(from: movies))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()

        let initialState: MoviesSearchViewModelOuput = .just(.idle)
        let emptySearchString: MoviesSearchViewModelOuput = searchInput.filter({ $0.isEmpty }).map({ _ in .idle }).eraseToAnyPublisher()
        let idle: MoviesSearchViewModelOuput = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()

        return Publishers.Merge(idle, movies).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModels(from movies: [Movie]) -> [MovieViewModel] {
        return movies.map({[unowned self] movie in
            return MovieViewModelBuilder.viewModel(from: movie, imageLoader: {[unowned self] movie in self.usageType.loadImage(for: movie, size: .small) })
        })
    }

}
