//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 4.01.2026.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()
    private let viewModel = HomeViewModel()

    private var filteredArticles: [Article] = []
    private var isSearching: Bool = false
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let stateView = StateView()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureNavigationBar()
        setupTableView()
        setupLoadingIndicator()
        setupStateView()
        configureSearchController()

        viewModel.delegate = self
        viewModel.fetchArticles()
    }

    // MARK: - Navigation Bar
    private func configureNavigationBar() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - TableView
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            ArticleCell.self,
            forCellReuseIdentifier: ArticleCell.identifier
        )
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Search
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for news"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Loading Indicator 
    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
   }
    
    private func setupStateView() {
        stateView.translatesAutoresizingMaskIntoConstraints = false
        stateView.isHidden = true

        view.addSubview(stateView)

        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        stateView.onAction = { [weak self] in
            self?.stateView.isHidden = true
            self?.viewModel.fetchArticles()
        }
    }
}


// MARK: - UITableViewDataSource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return isSearching
        ? viewModel.searchResults.count
        : viewModel.articles.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ArticleCell.identifier,
            for: indexPath
        ) as! ArticleCell

        let article = isSearching
        ? viewModel.searchResults[indexPath.row]
        : viewModel.articles[indexPath.row]

        cell.configure(with: article)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let article = isSearching
        ? viewModel.searchResults[indexPath.row]
        : viewModel.articles[indexPath.row]

        let detailVC = ArticleDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // Pagination
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {

        if isSearching {
            if indexPath.row == viewModel.searchResults.count - 1 {
                viewModel.loadMoreSearchResults()
            }
        } else {
            if indexPath.row == viewModel.articles.count - 1 {
                viewModel.fetchArticles()
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        if text.count >= 3 {
            isSearching = true
            viewModel.searchArticles(query: text)
        } else {
            isSearching = false
            tableView.reloadData()
        }
    }

}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {

    func didFetchArticles() {
        if viewModel.articles.isEmpty {
            stateView.configure(message: "No news found to display.",
            buttonTitle: "Refresh"
            )
            stateView.isHidden = false
        } else {
            stateView.isHidden = true
            tableView.reloadData()
        }
    }

    func didFail(error: Error) {
        stateView.configure(
            message: "An error has occurred.\nPlease check your internet connection."
        )
        stateView.isHidden = false
    }
    
    func didStartLoading() {
        loadingIndicator.startAnimating()
    }

    func didFinishLoading() {
        loadingIndicator.stopAnimating()
    }

}
