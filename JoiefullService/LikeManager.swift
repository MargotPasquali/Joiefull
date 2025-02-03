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
        print("[Manager] [init] ✅ LikeManager initialized")
    }
    
    public func getLikedProducts(from products: [Product]) -> [Product] {
        print("[Manager] [getLikedProducts] 🔍 Fetching liked products from list of \(products.count) products")
        
        let likedProductIds = userDefaultsManager.getLikedProductIds()
        print("[Manager] [getLikedProducts] ❤️ Liked product IDs: \(likedProductIds)")

        let filteredProducts = products.filter { product in
            likedProductIds.contains(String(product.id))
        }

        print("[Manager] [getLikedProducts] ✅ Found \(filteredProducts.count) liked products")
        return filteredProducts
    }
    
//    public func toggleLike(for product: Product) -> (isLiked: Bool, updatedLikes: Int) {
//        print("[Manager] [toggleLike] 🔘 Toggling like for product ID: \(product.id)")
//
//        let isLiked = userDefaultsManager.toggleProductLike(forProductId: String(product.id))
//        let updatedLikes = product.likes + (isLiked ? 1 : -1)
//
//        print("[Manager] [toggleLike] 💖 Like status changed to: \(isLiked), Updated likes: \(updatedLikes)")
//        return (isLiked, updatedLikes)
//    }
  
    public func isLiked(for product: Product) -> Bool {
        return userDefaultsManager.isProductLiked(String(product.id))
    }

    public func toggleLike(for product: Product) -> (isLiked: Bool, updatedLikes: Int) {
        print("[Manager] [toggleLike] 🔘 Toggling like for product ID: \(product.id)")

        // Basculer l'état du like
        let isLiked = userDefaultsManager.toggleProductLike(forProductId: String(product.id))
        print("[Manager] [toggleLike] 💖 Like status changed for product \(product.id): \(isLiked)")

        // Récupérer le nombre actuel de likes depuis UserDefaults
        let currentLikes = userDefaultsManager.getLikesCount(forProductId: String(product.id))
        print("[Manager] [toggleLike] 🔢 Retrieved current likes from storage for product \(product.id): \(currentLikes)")

        // Déterminer le bon nombre de likes (prendre la valeur initiale du produit si nécessaire)
        let baseCount = currentLikes == 0 ? product.likes : currentLikes
        print("[Manager] [toggleLike] 📊 Base likes count used for product \(product.id): \(baseCount)")

        // Calcul du nouveau nombre de likes
        let updatedLikes = max(0, baseCount + (isLiked ? 1 : -1)) // Empêche les valeurs négatives
        print("[Manager] [toggleLike] 🔄 Calculated updated likes for product \(product.id): \(updatedLikes)")

        // Sauvegarder le nombre mis à jour
        userDefaultsManager.saveLikesCount(updatedLikes, forProductId: String(product.id))
        print("[Manager] [toggleLike] 💾 Saved updated likes count for product \(product.id): \(updatedLikes)")

        return (isLiked, updatedLikes)
    }
    
    public func getUpdatedLikes(forProductId: Int) -> Int {
        userDefaultsManager.getLikesCount(forProductId: String(forProductId))
    }

}
