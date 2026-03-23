//
//  ImageLoader.swift
//  BookStore App
//
//  Created by Amit Kumar on 16/03/26.
//

import Foundation
import UIKit

final class ImageLoader {
    static let imageLoader = ImageLoader()
    private let cache =  NSCache<NSString, UIImage>()
    private init() {}
}

extension ImageLoader {
    func load(urlString: String,completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _ ,_) in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completion(image)
                return
            }
            
        }.resume()
    }
}
