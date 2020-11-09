//
//  MoviesSearchViewModelType.swift
//  Sample
//
//  Created by Mads Kleemann on 13/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Combine

struct MoviesDiscoverViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let selection: AnyPublisher<Int, Never>
}

enum MoviesDiscoverState {
    case loading
    case failure(Error)
    case success([MovieViewModel])
}

typealias MoviesDiscoverViewModelOuput = AnyPublisher<MoviesDiscoverState, Never>

protocol MoviesDiscoverViewModelType {
    func transform(input: MoviesDiscoverViewModelInput) -> MoviesDiscoverViewModelOuput
}
