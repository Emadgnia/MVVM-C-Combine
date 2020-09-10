//
//  Movie.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let overview: String
    let poster: String?
    let voteAverage: Float
    let releaseDate: String?
    let genreIds: [GenreId]?
    let genres: [Genre]?
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Movie: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case poster = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case genres = "genres"
    }
}

struct Movies {
    let items: [Movie]
}

extension Movies: Decodable {

    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}
