//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Ece Akcay on 6.01.2026.
//

import Foundation

///veri çekme, saklama ve yönetim işi  yapılıyor.
protocol HomeViewModelDelegate: AnyObject {
    func didFetchArticles()
    func didFail(error: Error)
    func didStartLoading()
    func didFinishLoading()
}
final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    //Weak (zayıf referans), bir nesneyi tutarken kullanılan özel bir referans türüdür. Amacı, memory leak (bellek sızıntısı) oluşmasını önlemektir.
    
    private(set) var articles: [Article] = []
    private var page = 1
    private var isLoading = false
    private(set) var searchResults: [Article] = []
    private var searchPage = 1
    private var currentQuery: String?
    
    func fetchArticles() {
        delegate?.didStartLoading()
        guard !isLoading else { return }
        isLoading = true
        
        NetworkManager.shared.fetchTopHeadlines(page: page) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.delegate?.didFinishLoading()
                
                switch result {
                case .success(let newArticles):
                    self?.articles.append(contentsOf: newArticles)
                    self?.page += 1
                    self?.delegate?.didFetchArticles()
                    
                case .failure(let error):
                    self?.delegate?.didFail(error: error)
                }
            }
        }
    }
    
    func searchArticles(query: String) {
        guard !isLoading else { return }

        // Yeni arama mı?
        if currentQuery != query {
            searchResults.removeAll()
            searchPage = 1
            currentQuery = query
        }

        isLoading = true
        delegate?.didStartLoading()

        NetworkManager.shared.searchArticles(query: query, page: searchPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.delegate?.didFinishLoading()

                switch result {
                case .success(let articles):
                    self?.searchResults.append(contentsOf: articles)
                    self?.searchPage += 1
                    self?.delegate?.didFetchArticles()

                case .failure(let error):
                    self?.delegate?.didFail(error: error)
                }
            }
        }
    }
    
    func loadMoreSearchResults() {
        guard let query = currentQuery else { return }
        searchArticles(query: query)
    }
}
