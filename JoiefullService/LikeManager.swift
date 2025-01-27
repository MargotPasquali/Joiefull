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
   let UserDefaultsManager: UserDefaultsManager
   
   public init(UserDefaultsManager: UserDefaultsManager) {
       self.UserDefaultsManager = UserDefaultsManager
   }
   
   public func getLikedProducts(from products: [Product]) -> [Product] {
       print("📋 Getting liked products...")
       let likedProductIds = UserDefaultsManager.getLikedProductIds()
       print("🔍 Found liked product IDs: \(likedProductIds)")
       let filteredProducts = products.filter { product in
           likedProductIds.contains(String(product.id))
       }
       print("✅ Filtered products count: \(filteredProducts.count)")
       return filteredProducts
   }
   
   public func toggleLike(for product: Product) -> (isLiked: Bool, updatedLikes: Int) {
       print("💫 Toggling like for product \(product.id)")
       print("Current likes: \(product.likes)")
       let isLiked = UserDefaultsManager.toggleProductLike(forProductId: String(product.id))
       let updatedLikes = product.likes + (isLiked ? 1 : -1)
       print("New state - isLiked: \(isLiked), updatedLikes: \(updatedLikes)")
       return (isLiked, updatedLikes)
   }
       
   public func isLiked(for product: Product) -> Bool {
       let isLiked = UserDefaultsManager.isProductLiked(String(product.id))
       print("❤️ Checking if product \(product.id) is liked: \(isLiked)")
       return isLiked
   }
}
