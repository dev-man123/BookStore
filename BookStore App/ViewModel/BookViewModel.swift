//
//  BookViewModel.swift
//  BookStore App
//
//  Created by Amit Kumar on 17/03/26.
//
import Foundation

protocol BookViewModelDelegate: AnyObject {
    func didUpdateBooks()
}

final class BookViewModel {
    weak var delegate: BookViewModelDelegate?
    private(set) var books: [Book] = []
    private(set) var filteredBooks: [Book] = []
    private var selectedTags: Set<Tag> = []
    private var searchQuery: String = ""
    init() {
        setupBooks()
    }
}

extension BookViewModel {
    func setupBooks() {
        books = BookLoader.bookLoader.load()
        filteredBooks = books
        delegate?.didUpdateBooks()
    }
    
    func applyFilters() {
        var result = books
        if !selectedTags.isEmpty {
            result = result.filter { book in selectedTags.isSubset(of: book.tag)}
        }
        if !searchQuery.isEmpty {
            result = result.filter { book in
                book.author.lowercased().contains(searchQuery.lowercased()) ||
                book.title.lowercased().contains(searchQuery.lowercased())
            }
        }
        filteredBooks = result
        delegate?.didUpdateBooks()
    }
    
    func search(query: String) {
        searchQuery = query
        applyFilters()
    }
    
    func toggleTag(tag: Tag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        }
        else {
            selectedTags.insert(tag)
        }
        applyFilters()
    }
    
    func isSelectedTag(tag: Tag) -> Bool {
        if selectedTags.contains(tag) {
            return true
        }
        return false
    }
    
    func clearFilters() {
        selectedTags.removeAll()
        applyFilters()
    }
    
    func isAllSelected() -> Bool {
        if selectedTags.isEmpty && searchQuery.isEmpty {
            return true
        }
        return false
    }
    
    func numberOfBooks() -> Int {
        return filteredBooks.count
    }
    
    func toggleIsExpanded(bookId: String) {
        let bookIndex = filteredBooks.firstIndex(where: {$0.id == bookId})
        if let bookIndex = bookIndex {
            filteredBooks[bookIndex].isExpanded.toggle()
            if let masterIndex = books.firstIndex(where: {$0.id == bookId}) {
                books[masterIndex].isExpanded = filteredBooks[bookIndex].isExpanded
                }
        }
    }
    func sortByPrice(ascending: Bool) {
        if ascending {
            filteredBooks.sort {$0.price < $1.price}
        }
        else {
            filteredBooks.sort {$0.price > $1.price}
        }
        delegate?.didUpdateBooks()
    }
        
}
