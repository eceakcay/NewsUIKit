//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Ece Akcay on 6.01.2026.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchTopHeadlines(page: Int, completion: @escaping(Result<[Article], Error>) -> Void) {
        
        let urlString = "\(NetworkConstants.baseURL)/top-headlines?country=us&page=\(page)&apiKey=\(NetworkConstants.apiKey)"
        print("REQUEST URL:", urlString)


        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let reponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(reponse.articles))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchArticles(query: String, page : Int, completion: @escaping(Result <[Article], Error>) ->Void) {
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        let urlString =
        "\(NetworkConstants.baseURL)/everything?q=\(encodedQuery)&page=\(page)&apiKey=\(NetworkConstants.apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error)); return
            }
            guard let data = data else { return }
            do {
                let reponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(reponse.articles))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
