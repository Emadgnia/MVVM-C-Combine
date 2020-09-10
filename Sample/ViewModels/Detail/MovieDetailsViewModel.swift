//
//  MovieDetailsViewModel.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit
import Combine

class MovieDetailsViewModel: MovieDetailsViewModelType {

    private let movieId: Int
    private let usageType: MoviesUsageType

    init(movieId: Int, usageType: MoviesUsageType) {
        self.movieId = movieId
        self.usageType = usageType
    }

    func transform(input: MovieDetailsViewModelInput) -> MovieDetailsViewModelOutput {
        let movieDetails = input.appear
            .flatMap({[unowned self] _ in self.usageType.movieDetails(with: self.movieId) })
            .map({ result -> MovieDetailsState in
                switch result {
                    case .success(let movie): return .success(self.viewModel(from: movie))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        let loading: MovieDetailsViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()

        return Publishers.Merge(loading, movieDetails).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModel(from movie: Movie) -> MovieViewModel {
        return MovieViewModelBuilder.viewModel(from: movie, imageLoader: {[unowned self] movie in self.usageType.loadImage(for: movie, size: .original) })
    }
}
