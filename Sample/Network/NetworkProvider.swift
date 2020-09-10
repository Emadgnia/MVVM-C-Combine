//
//  NetworkProvider.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Foundation

class NetworkProvider {
    let network: NetworkServiceType
    let imageLoader: ImageServiceType

    static func defaultProvider() -> NetworkProvider {
        let network = NetworkService()
        let imageLoader = ImageService()
        return NetworkProvider(network: network, imageLoader: imageLoader)
    }

    init(network: NetworkServiceType, imageLoader: ImageServiceType) {
        self.network = network
        self.imageLoader = imageLoader
    }
}
