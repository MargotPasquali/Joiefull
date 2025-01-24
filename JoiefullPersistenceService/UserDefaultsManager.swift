//
//  UserDefaultsManager.swift
//  JoiefullPersistenceService
//
//  Created by Margot Pasquali on 23/01/2025.
//

import Foundation
import JoiefullModels

public final class UserDefaultsManager {
    
    // MARK: - Constants
    private let ratingKey = "rating_user_101_product_"
    private let likesKey = "likes_user_101_product_"
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Rating
    
    public func saveRating(_ rating: ProductRating, forProductId id: String) {
       if let encoded = try? JSONEncoder().encode(rating) {
           print("Saving rating for product \(id): score=\(rating.score), comment=\(rating.comment)")
           UserDefaults.standard.set(encoded, forKey: ratingKey + id)
       }
    }

    public func getRating(forProductId id: String) -> ProductRating? {
       guard let data = UserDefaults.standard.data(forKey: ratingKey + id) else {
           print("No rating found for product \(id)")
           return nil
       }
       let rating = try? JSONDecoder().decode(ProductRating.self, from: data)
       print("Retrieved rating for product \(id): \(String(describing: rating))")
       return rating
    }

    public func isProductLiked(_ productId: String) -> Bool {
       let isLiked = UserDefaults.standard.bool(forKey: likesKey + productId)
       print("Product \(productId) liked status: \(isLiked)")
       return isLiked
    }

    public func toggleProductLike(forProductId id: String) -> Bool {
       let newValue = !isProductLiked(id)
       print("Toggling like for product \(id) to \(newValue)")
       UserDefaults.standard.set(newValue, forKey: likesKey + id)
       return newValue
    }

    public func getLikedProductIds() -> [String] {
       let ids = UserDefaults.standard.dictionaryRepresentation()
           .filter { $0.key.starts(with: likesKey) && $0.value as? Bool == true }
           .map { $0.key.replacingOccurrences(of: likesKey, with: "") }
       print("Retrieved liked product IDs: \(ids)")
       return ids
    }
    
}
