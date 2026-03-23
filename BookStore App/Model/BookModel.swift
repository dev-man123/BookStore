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
}
