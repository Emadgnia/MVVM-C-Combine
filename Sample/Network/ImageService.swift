//
//  ImageService.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageServiceType: AnyObject {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}


final class ImageService: ImageServiceType {


    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .print("Image loading \(url):")
            .eraseToAnyPublisher()
    }
}
