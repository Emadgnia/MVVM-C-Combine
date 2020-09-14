//
//  AlertViewController.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit

struct AlertViewController {
    
    func showNoResults(sender: UIViewController) {
        render(viewModel: AlertViewModel.noResults, sender: sender)
    }

    func showDataLoadingError(sender: UIViewController) {
        render(viewModel: AlertViewModel.dataLoadingError, sender: sender)
    }

    fileprivate func render(viewModel: AlertViewModel, sender: UIViewController) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.description, preferredStyle: .alert)
        alert.addAction(.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        sender.show(alert, sender: nil)

    }
}
