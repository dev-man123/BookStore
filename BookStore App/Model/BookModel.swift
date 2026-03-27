//
//  BookModel.swift
//  BookStore App
//
//  Created by Amit Kumar on 16/03/26.
//

struct Book: Codable {
    let id: String
    let title: String
    let author: String
    let description: String
    let rating: Double
    let price: Int
    let tag: [Tag]
    let imageUrl: String
    var isExpanded: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, title, author, description, rating, price, tag, imageUrl
        
    }
}
