//
//  MovieSearchTableViewCell.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit
import Combine

class MovieSearchTableViewCell: UITableViewCell, NibProvidable, ReusableView {

    @IBOutlet private var title: UILabel!
    @IBOutlet private var subtitle: UILabel!
    @IBOutlet private var rating: UILabel!
    @IBOutlet private var poster: UIImageView!
    private var cancellable: AnyCancellable?

    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }

    func bind(to viewModel: MovieViewModel) {
        cancelImageLoading()
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        rating.text = viewModel.rating
        cancellable = viewModel.poster.sink { [unowned self] image in self.showImage(image: image) }
    }

    private func showImage(image: UIImage?) {
        cancelImageLoading()
        UIView.transition(with: self.poster,
        duration: 0.3,
        options: [.curveEaseOut, .transitionCrossDissolve],
        animations: {
            self.poster.image = image
        })
    }

    private func cancelImageLoading() {
        poster.image = nil
        cancellable?.cancel()
    }

}
