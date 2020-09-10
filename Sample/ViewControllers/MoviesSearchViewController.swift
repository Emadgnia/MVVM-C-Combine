//
//  MoviesSearchViewController.swift
//  Sample
//
//  Created by Emad Ghorbaninia on 09/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit
import Combine

class MoviesSearchViewController : UIViewController {

    private var cancellables: [AnyCancellable] = []
    private let viewModel: MoviesSearchViewModelType
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    private lazy var loadingView: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .medium)
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()
    private lazy var alertViewController = AlertViewController()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.delegate = self
        return searchController
    }()
    private lazy var dataSource = makeDataSource()

    init(viewModel: MoviesSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }

    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Movies", comment: "Top Movies")
        view.addSubview(self.tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.tableFooterView = UIView()
        
        tableView.registerNib(cellClass: MovieSearchTableViewCell.self)
        tableView.dataSource = dataSource

        navigationItem.searchController = self.searchController
        searchController.isActive = true

    }

    private func bind(to viewModel: MoviesSearchViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = MoviesSearchViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               search: search.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }

    private func render(_ state: MoviesSearchState) {
        switch state {
        case .idle:
            loadingView.stopAnimating()
            update(with: [], animate: true)
        case .loading:
            loadingView.startAnimating()
            update(with: [], animate: true)
        case .noResults:
            alertViewController.showNoResults(sender: self)
            loadingView.stopAnimating()
            update(with: [], animate: true)
        case .failure:
            alertViewController.showDataLoadingError(sender: self)
            loadingView.stopAnimating()
            update(with: [], animate: true)
        case .success(let movies):
            loadingView.stopAnimating()
            update(with: movies, animate: true)
        }
    }
}

fileprivate extension MoviesSearchViewController {
    enum Section: CaseIterable {
        case movies
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, MovieViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, movieViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: MovieSearchTableViewCell.self) else {
                    assertionFailure("Failed to dequeue \(MovieSearchTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(to: movieViewModel)
                return cell
            }
        )
    }

    func update(with movies: [MovieViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .movies)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension MoviesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.send("")
    }
}

extension MoviesSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
