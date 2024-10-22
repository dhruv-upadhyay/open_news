//
//  NewsViewModel.swift
//  News
//
//  Created by Dhruv Upadhyay on 14/10/24.
//

import Foundation
import Combine
import CoreData

class NewsViewModel: NSObject, ObservableObject {
    @Published var articles = [MappedArticle]()
    @Published var isLoading: Bool = true
    @Published var options = [Option]()
    @Published var selectedOption: Option?
    @Published var bookmarkToggle: Bool = false
    
    override init() {
        super.init()
        addOptions()
        fetchNews()
    }
    
    private func addOptions() {
        options = [Option(title: Titles.topHeadlines, apiURL: NewsURLs.topNews), Option(title: Titles.bbc, apiURL: NewsURLs.bbcNews), Option(title: Titles.bitcoin, apiURL: NewsURLs.bitcoinNews), Option(title: Titles.apple, apiURL: NewsURLs.appleNews), Option(title: Titles.techCrunch, apiURL: NewsURLs.techCrunch)]
        selectedOption = options.first
    }

    @objc func fetchBookmarks() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchBookmarks), name: .bookmarkUpdate, object: nil)
        selectedOption = nil
        bookmarkToggle.toggle()
        DispatchQueue.main.async {
            self.isLoading = false
            self.articles = BookmarkManager.shared.getBookMarksArticles()
        }
    }
    
    func fetchNews() {
        bookmarkToggle = false
        NotificationCenter.default.removeObserver(self)
        let baseURL = selectedOption?.apiURL ?? ""
        guard let url = URL(string: baseURL + apiKey) else {
            return
        }
        
        NetworkService.shared.fetchData(from: url, type: ArticleResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let newsResponse):
                let mappedArticlesArray = newsResponse.articles.compactMap { article -> MappedArticle? in
                    // Safely unwrap and convert the URL strings to URL type
                    guard article.title != "[Removed]" else { return nil }
                    
                    guard let link = URL(string: article.url) else { return nil }
                    let imageUrl = URL(string: article.urlToImage ?? "")
                    
                    // Create a MappedArticle object
                    return MappedArticle(
                        title: article.title,
                        description: article.description,
                        link: link,
                        imageUrl: imageUrl,
                        publishedAt: article.publishedAt
                    )
                }

                DispatchQueue.main.async {
                    strongSelf.isLoading = false
                    strongSelf.articles = mappedArticlesArray
                }
            case .failure(let error):
                print("\(Messages.failedToFetch) \(String(describing: error))")
            }
        }
    }
}

extension NewsViewModel {
    func getOpecity() -> Double {
        return (articles.isEmpty && !isLoading) ? 1 : 0
    }
    
    func isBookMarked() -> Bool {
        return bookmarkToggle
    }
}
