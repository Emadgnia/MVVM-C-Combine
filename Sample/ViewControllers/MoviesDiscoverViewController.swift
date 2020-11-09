//
//  MoviesDiscoverViewController.swift
//  Sample
//
//  Created by Mads Kleemann on 13/09/2020.
//  Copyright © 2020 Nuuday. All rights reserved.
//

import UIKit
import Combine

class MoviesDiscoverViewController: UIViewController, UITableViewDelegate {
    
    private var cancellables: [AnyCancellable] = []
    private var tableView: UITableView {
        let tableView = UITableView(frame: self.view.frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    private lazy var dataSource = makeDataSource()
    private let viewModel: MoviesDiscoverViewModelType
    
    private let selection = CurrentValueSubject<Int, Never>(0)
    private let appear = PassthroughSubject<Void, Never>()
    
    enum Section: CaseIterable {
        case movies
    }
    
    init(viewModel: MoviesDiscoverViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Discover"
        configureUI()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appear.send(())
    }
    
    private func bind(to viewModel: MoviesDiscoverViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = MoviesDiscoverViewModelInput(appear: appear.eraseToAnyPublisher(), selection: selection.eraseToAnyPublisher())

       let output = viewModel.transform(input: input)

       output.sink(receiveValue: { state in
           self.render(state)
       }).store(in: &cancellables)
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
    
    private func render(_ state: MoviesDiscoverState) {
        switch state {
        case .loading:
            update(with: [], animate: true)
        case .failure:
            update(with: [], animate: true)
        case .success(let movies):
            update(with: movies, animate: true)
        }
    }
    
    private func configureUI() {
        view.addSubview(self.tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.tableFooterView = UIView()
        tableView.registerNib(cellClass: MovieSearchTableViewCell.self)
        tableView.dataSource = dataSource
    }

    func update(with movies: [MovieViewModel], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(movies, toSection: .movies)
        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
