//
//  BookService.swift
//  BookStore App
//
//  Created by Amit Kumar on 16/03/26.
//

import Foundation

final class BookLoader {
    static let bookLoader: BookLoader = BookLoader()
    private init() {}
}

private extension BookLoader {
    func JSONBookLoader() -> [Book] {
        guard let url = Bundle.main.url(forResource: "books", withExtension: "json") , let jsonData = try? Data(contentsOf: url), let jsonBooks = try? JSONDecoder().decode([Book].self, from: jsonData) else {
             return []
        }
        return jsonBooks
    }
}
extension BookLoader {
    func load() -> [Book] {
        let jsonBooks = JSONBookLoader()
        guard let customData = UserDefaults.standard.data(forKey:"custom_books"), let customBooks = try? JSONDecoder().decode([Book].self, from: customData) else {
            return jsonBooks
        }
        return jsonBooks + customBooks
    }
}
