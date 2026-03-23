//
//  WishListManager.swift
//  BookStore App
//
//  Created by Amit Kumar on 16/03/26.
//

import Foundation

final class WishListManager {
    static let wishlistManager = WishListManager()
    private init() {}
    private let key = "wishlist"
}

extension WishListManager {
    func getWishList() -> [String] {
        guard let data = UserDefaults.standard.stringArray(forKey: key) else {
            return []
        }
        return data
    }
    
    func addToWishList(id: String) {
        var wishList = getWishList()
        if !wishList.contains(id) {
            wishList.append(id)
        }
        UserDefaults.standard.set(wishList, forKey: key)
    }
    
    func removeFromWishList(id: String) {
        var wishList = getWishList()
        wishList.removeAll {$0 == id}
        UserDefaults.standard.set(wishList, forKey: key)
    }
    
    func contains(id: String) -> Bool {
        return getWishList().contains(id)
    }
    
}
