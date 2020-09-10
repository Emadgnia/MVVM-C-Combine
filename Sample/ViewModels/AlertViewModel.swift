//
//  AlertViewModel.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import Foundation

struct AlertViewModel {
    let title: String
    let description: String?

    static var noResults: AlertViewModel {
        let title = NSLocalizedString("No movies found!", comment: "No movies found!")
        let description = NSLocalizedString("Try searching again...", comment: "Try searching again...")
        return AlertViewModel(title: title, description: description)
    }

    static var dataLoadingError: AlertViewModel {
        let title = NSLocalizedString("Can't load search results!", comment: "Can't load search results!")
        let description = NSLocalizedString("Something went wrong. Try searching again...", comment: "Something went wrong. Try searching again...")
        return AlertViewModel(title: title, description: description)
    }
}
