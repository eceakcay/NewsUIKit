//
//  Article.swift
//  NewsApp
//
//  Created by Ece Akcay on 4.01.2026.
//

import Foundation

struct Article: Codable {

    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let content: String?
    let publishedAt: String?
    let url: String?
    let urlToImage: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
