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
    
    public func toggleLike(for product: Product) -> (isLiked: Bool, updatedLikes: Int) {
        let isLiked = userDefaultsManager.toggleProductLike(forProductId: String(product.id))
        let updatedLikes = product.likes + (isLiked ? 1 : -1)
        return (isLiked, updatedLikes)
    }
    
    public func isLiked(for product: Product) -> Bool {
        let isLiked = userDefaultsManager.isProductLiked(String(product.id))
        return isLiked
    }
}
