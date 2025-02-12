//
//  LikeManager.swift
//  JoiefullService
//
//  Created by Margot Pasquali on 23/01/2025.
//

import Foundation
import JoiefullModels
import JoiefullPersistenceService

public final class LikeManager {
    let userDefaultsManager: PersistenceService
    
    public init(userDefaultsManager: PersistenceService = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    public func getLikedProducts(from products: [Product]) -> [Product] {
        let likedProductIds = userDefaultsManager.getLikedProductIds()
        
        let filteredProducts = products.filter { product in
            likedProductIds.contains(String(product.id))
        }
        return filteredProducts
    }
    
    
    public func isLiked(for product: Product) -> Bool {
        return userDefaultsManager.isProductLiked(String(product.id))
    }
    
    public func toggleLike(for product: Product) -> (isLiked: Bool, updatedLikes: Int) {
        // Toggle the like status
        let isLiked = userDefaultsManager.toggleProductLike(forProductId: String(product.id))
        
        // Retrieve the current number of likes (saved or from the API)
        let currentLikes = getUpdatedLikes(for: product)
        
        // Calculate the new number of likes
        let updatedLikes = currentLikes + (isLiked ? 1 : -1)
        
        // Save the new count
        userDefaultsManager.saveLikesCount(updatedLikes, forProductId: String(product.id))
        
        return (isLiked, updatedLikes)
    }

    public func getUpdatedLikes(for product: Product) -> Int {
        let savedLikes = userDefaultsManager.getLikesCount(forProductId: String(product.id))
        if savedLikes == 0 {
            // If we don’t have saved likes yet, save the likes from the API
            userDefaultsManager.saveLikesCount(product.likes, forProductId: String(product.id))
            return product.likes
        }
        return savedLikes
    }

    
}
