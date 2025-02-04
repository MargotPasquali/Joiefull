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
        let isLiked = userDefaultsManager.toggleProductLike(forProductId: String(product.id))
        
        let currentLikes = userDefaultsManager.getLikesCount(forProductId: String(product.id))
        let likes = currentLikes > 0 ? currentLikes : product.likes
        
        let updatedLikes = likes + (isLiked ? 1 : -1)
        userDefaultsManager.saveLikesCount(updatedLikes, forProductId: String(product.id))
        
        return (isLiked, updatedLikes)
    }
    
    public func getUpdatedLikes(for product: Product) -> Int {
        let savedLikes = userDefaultsManager.getLikesCount(forProductId: String(product.id))
        return savedLikes == 0 ? product.likes : savedLikes
        // TODO : voir si ici la sauvegarde s'effectue bien
    }
    
}
