//  HomeViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 4.01.2026.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - UI Components
    // Modern iOS tasarımı için .insetGrouped kullanımı doğrudur
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 320
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let stateView: StateView = {
        let view = StateView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let refreshControl = UIRefreshControl()

    // MARK: - Properties
    private let viewModel = HomeViewModel()
    private var isSearching = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        setupSearchController()
        
        viewModel.fetchArticles()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        configureNavigationBar()
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(stateView)

        // Pull to Refresh
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // StateView Action
        stateView.onAction = { [weak self] in
            self?.stateView.isHidden = true
            self?.viewModel.fetchArticles()
        }
    }

    private func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
    }

    private func configureNavigationBar() {
        title = "Top Stories"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let profileImage = UIImage(systemName: "person.circle.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: profileImage,
            style: .plain,
            target: self,
            action: #selector(didTapProfile)
        )
        navigationController?.navigationBar.tintColor = .label
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search global news..."
        searchController.searchBar.searchBarStyle = .minimal
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func didPullToRefresh() {
        viewModel.fetchArticles()
    }

    @objc private func didTapProfile() {
        let settingsVC = SettingsViewController(style: .insetGrouped)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func triggerSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare() // Performans için önceden hazırla
        generator.selectionChanged()
    }
}

// MARK: - UITableViewDataSource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? viewModel.searchResults.count : viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }

        let article = isSearching ? viewModel.searchResults[indexPath.row] : viewModel.articles[indexPath.row]
        cell.configure(with: article)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        triggerSelectionFeedback()
        
        let article = isSearching ? viewModel.searchResults[indexPath.row] : viewModel.articles[indexPath.row]
        let detailVC = ArticleDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = isSearching ? viewModel.searchResults.count : viewModel.articles.count
        // Veri bittiğinde yeni sayfa yükleme
        if indexPath.row == count - 1 && count > 0 {
            isSearching ? viewModel.loadMoreSearchResults() : viewModel.fetchArticles()
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
        } else if text.isEmpty {
            isSearching = false
            tableView.reloadData()
        }
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didFetchArticles() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            
            let isEmpty = self.isSearching ? self.viewModel.searchResults.isEmpty : self.viewModel.articles.isEmpty
            
            if isEmpty {
                self.stateView.configure(message: "No news found at the moment.\nPlease try again later.",
                                         buttonTitle: "Refresh")
                self.stateView.isHidden = false
            } else {
                self.stateView.isHidden = true
                self.tableView.reloadData()
            }
        }
    }

    func didFail(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.stateView.configure(message: "Something went wrong.\nPlease check your connection.")
            self?.stateView.isHidden = false
        }
    }
    
    func didStartLoading() {
        if !refreshControl.isRefreshing {
            loadingIndicator.startAnimating()
        }
    }

    func didFinishLoading() {
        loadingIndicator.stopAnimating()
    }
}
