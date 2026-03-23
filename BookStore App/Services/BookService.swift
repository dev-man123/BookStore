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

extension BookLoader {
    func load() -> [Book] {
        guard let url = Bundle.main.url(forResource: "books", withExtension: "json") , let data = try? Data(contentsOf: url), let books = try? JSONDecoder().decode([Book].self, from: data) else {
             return []
        }
        return books
    }
}
