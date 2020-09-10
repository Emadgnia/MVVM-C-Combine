//
//  NetworkService.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Foundation
import Combine


protocol NetworkServiceType: AnyObject {

    @discardableResult
    func load<T: Decodable>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never>
}

/// Defines the Network service errors.
enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}


final class NetworkService: NetworkServiceType {
    private let session: URLSession

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> {
        guard let request = resource.request else {
            return .just(.failure(NetworkError.invalidRequest))
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.invalidRequest }
            .print()
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(NetworkError.invalidResponse)
                }

                guard 200..<300 ~= response.statusCode else {
                    return .fail(NetworkError.dataLoadingError(statusCode: response.statusCode, data: data))
                }
                return .just(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
        .map { .success($0) }
        .catch ({ error -> AnyPublisher<Result<T, NetworkError>, Never> in
            return .just(.failure(NetworkError.jsonDecodingError(error: error)))
        })
        .eraseToAnyPublisher()
    }

}

struct Resource<T: Decodable> {
    let url: URL
    let parameters: [String: CustomStringConvertible]
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}

extension Resource {

    static func movies(query: String) -> Resource<Movies> {
        let url = ApiConstants.baseUrl.appendingPathComponent("/search/movie")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "query": query,
            "language": Locale.preferredLanguages[0]
            ]
        return Resource<Movies>(url: url, parameters: parameters)
    }

    static func details(movieId: Int) -> Resource<Movie> {
        let url = ApiConstants.baseUrl.appendingPathComponent("/movie/\(movieId)")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "language": Locale.preferredLanguages[0]
            ]
        return Resource<Movie>(url: url, parameters: parameters)
    }
}
