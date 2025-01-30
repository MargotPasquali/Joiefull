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
    let UserDefaultsManager: PersistenceService
    
    public init(UserDefaultsManager: PersistenceService) {
        self.UserDefaultsManager = UserDefaultsManager
    }
    
    public func getLikedProducts(from products: [Product]) -> [Product] {
        let likedProductIds = UserDefaultsManager.getLikedProductIds()
        let filteredProducts = products.filter { product in
            likedProductIds.contains(String(product.id))
        }
        return filteredProducts
    }
    
    public func toggleLike(for product: Product) -> (isLiked: Bool, updatedLikes: Int) {
        let isLiked = UserDefaultsManager.toggleProductLike(forProductId: String(product.id))
        let updatedLikes = product.likes + (isLiked ? 1 : -1)
        return (isLiked, updatedLikes)
    }
    
    public func isLiked(for product: Product) -> Bool {
        let isLiked = UserDefaultsManager.isProductLiked(String(product.id))
        return isLiked
    }
}
