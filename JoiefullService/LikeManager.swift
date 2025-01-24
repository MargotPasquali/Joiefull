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
    
    // MARK: - Constants
    private let products: [Product]
    let UserDefaultsManager: UserDefaultsManager
    
    public init(products: [Product], UserDefaultsManager: UserDefaultsManager) {
        self.products = products
        self.UserDefaultsManager = UserDefaultsManager
    }
    
    
    // MARK: - Functions
    
    public func getLikedProducts() -> [Product] {
        let likedProductIds = UserDefaultsManager.getLikedProductIds()
        return products.filter { product in
            likedProductIds.contains(String(product.id))
        }
    }
    
    public func toggleLike(for product: Product) -> (isLiked: Bool, updatedLikes: Int) {
        let isLiked = UserDefaultsManager.toggleProductLike(forProductId: String(product.id))
        let updatedLikes = product.likes + (isLiked ? 1 : -1)
        return (isLiked, updatedLikes)
    }
        
    public func isLiked(for product: Product) -> Bool {
       UserDefaultsManager.isProductLiked(String(product.id))
    }
    }

