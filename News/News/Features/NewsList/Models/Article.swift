//
//  Article.swift
//  News
//
//  Created by Dhruv Upadhyay on 14/10/24.
//

import Foundation

struct Article: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String

    private enum CodingKeys: String, CodingKey {
        case title, description, url, urlToImage, publishedAt
    }
}

struct ArticleResponse: Decodable {
    let articles: [Article]
}

struct MappedArticle: Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    let link: URL
    let imageUrl: URL?
    let publishedAt: String
}

struct Option: Identifiable {
    let id = UUID()
    let title: String
    let apiURL: String
}
