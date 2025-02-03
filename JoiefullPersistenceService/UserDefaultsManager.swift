//
//  UserDefaultsManager.swift
//  JoiefullPersistenceService
//
//  Created by Margot Pasquali on 23/01/2025.
//
import Foundation
import JoiefullModels

public class UserDefaultsManager {
    
    // MARK: - Constants
    private let ratingKey = "rating_user_101_product_"
    private let likesKey = "likes_user_101_product_"
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Rating
    
    open func saveRating(_ rating: ProductRating, forProductId id: String) {
        let encoded = try? JSONEncoder().encode(rating)
            UserDefaults.standard.set(encoded, forKey: ratingKey + id)
    }

    open func getRating(forProductId id: String) -> ProductRating? {
           guard let data = UserDefaults.standard.data(forKey: ratingKey + id) else {
               return nil
           }
           let rating = try? JSONDecoder().decode(ProductRating.self, from: data)
           return rating
        }

    open func isProductLiked(_ productId: String) -> Bool {
        let isLiked = UserDefaults.standard.bool(forKey: likesKey + productId)
        print("[Storage] [isProductLiked] 💡 Checking if product \(productId) is liked: \(isLiked)")
        return isLiked
    }

    open func toggleProductLike(forProductId id: String) -> Bool {
        let newValue = !isProductLiked(id)
        print("[Storage] [toggleProductLike] 🔘 Toggling like for product \(id) to \(newValue)")
        
        UserDefaults.standard.set(newValue, forKey: likesKey + id)
        print("[Storage] [toggleProductLike] ✅ Like status updated successfully")
        
        return newValue
    }

    open func getLikedProductIds() -> [String] {
        print("[Storage] [getLikedProductIds] 🔍 Retrieving liked product IDs")

        let ids = UserDefaults.standard.dictionaryRepresentation()
            .filter { $0.key.starts(with: likesKey) && $0.value as? Bool == true }
            .map { $0.key.replacingOccurrences(of: likesKey, with: "") }

        print("[Storage] [getLikedProductIds] ✅ Liked product IDs: \(ids)")
        return ids
    }
    
    open func getLikesCount(forProductId id: String) -> Int {
        let likes = UserDefaults.standard.integer(forKey: "likes_count_" + id)
        print("[Storage] [getLikesCount] 🔢 Retrieved \(likes) likes for product \(id)")
        return likes
    }

    open func saveLikesCount(_ count: Int, forProductId id: String) {
        UserDefaults.standard.set(count, forKey: "likes_count_" + id)
        print("[Storage] [saveLikesCount] 💾 Saved \(count) likes for product \(id)")
    }
}
