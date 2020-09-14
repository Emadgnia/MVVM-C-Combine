//
//  MovieDetailsViewModelType.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit
import Combine

//INPUT()
struct MovieDetailsViewModelInput {
    /// called when a view becomes visible
    let appear: AnyPublisher<Void, Never>
}

// OUTPUT
enum MovieDetailsState {
    case loading
    case success(MovieViewModel)
    case failure(Error)
}

extension MovieDetailsState: Equatable {
    static func == (lhs: MovieDetailsState, rhs: MovieDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsMovie), .success(let rhsMovie)): return lhsMovie == rhsMovie
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias MovieDetailsViewModelOutput = AnyPublisher<MovieDetailsState, Never>

protocol MovieDetailsViewModelType: class {
    func transform(input: MovieDetailsViewModelInput) -> MovieDetailsViewModelOutput
}
