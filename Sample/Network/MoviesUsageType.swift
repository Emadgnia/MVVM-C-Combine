//
//  MoviesUsageType.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage

protocol MoviesUsageTypeProtocol {

    // Runs movies search with a query string
    func searchMovies(with name: String) -> AnyPublisher<Result<[Movie], Error>, Never>

    // Fetches details for movie with specified id
    func movieDetails(with id: Int) -> AnyPublisher<Result<Movie, Error>, Never>

    // Loads image for the given movie
    func loadImage(for movie: Movie, size: ImageSize) -> AnyPublisher<UIImage?, Never>
}

final class MoviesUsageType: MoviesUsageTypeProtocol {

    private let networkService: NetworkServiceType
    private let imageLoaderService: ImageServiceType

    init(networkService: NetworkServiceType, imageLoaderService: ImageServiceType) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }

    func searchMovies(with name: String) -> AnyPublisher<Result<[Movie], Error>, Never> {
        return networkService
            .load(Resource<Movies>.movies(query: name))
            .map({ (result: Result<Movies, NetworkError>) -> Result<[Movie], Error> in
                switch result {
                case .success(let movies): return .success(movies.items)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func movieDetails(with id: Int) -> AnyPublisher<Result<Movie, Error>, Never> {
        return networkService
            .load(Resource<Movie>.details(movieId: id))
            .map({ (result: Result<Movie, NetworkError>) -> Result<Movie, Error> in
                switch result {
                case .success(let movie): return .success(movie)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func loadImage(for movie: Movie, size: ImageSize) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(movie.poster) }
        .flatMap({[unowned self] poster -> AnyPublisher<UIImage?, Never> in
            guard let poster = movie.poster else { return .just(nil) }
            let url = size.url.appendingPathComponent(poster)
            return self.imageLoaderService.loadImage(from: url)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }

}

