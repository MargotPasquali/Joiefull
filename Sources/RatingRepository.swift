//
//  RatingRepository.swift
//  Joiefull
//
//  Created by Margot Pasquali on 20/01/2025.
//
import Foundation
import JoiefullModels
import JoiefullPersistenceService

final class RatingRepository {
    
    // MARK: - Constants
    private let persistenceService: UserDefaultsManager
    
    init(persistenceService: UserDefaultsManager) {
        self.persistenceService = persistenceService
    }
    
    // MARK: - Likes

    /// Retrieves a list of IDs of products that the user has liked.
    func getLikedProductIDs() -> [Int] {
        return persistenceService.getLikedProductIDs()
    }
    
    /// Toggles the like state for a specific product.
    func toggleLike(for productID: Int) {
        print("📚 [Repository] Toggling like for product \(productID)")
        persistenceService.toggleLike(productID: productID)
        print("📚 [Repository] New like state: \(isProductLiked(productID: productID))")
    }
    
    /// Checks whether a specific product is liked by the user.
    func isProductLiked(productID: Int) -> Bool {
        let isLiked = persistenceService.isProductLiked(productID: productID)
        print("📚 [Repository] Checking if product \(productID) is liked: \(isLiked)")
        return isLiked
    }
    
    // MARK: - Ratings

    /// Retrieves the user's rating for a specific product.
    func getUserRating(for productID: Int) -> Int? {
        return persistenceService.getUserRating(for: productID)
    }
    
    /// Saves the user's rating for a specific product.
    func saveUserRating(for productID: Int, rating: Int) {
        persistenceService.saveRating(for: productID, rating: rating)
    }
    
    /// Calculates and retrieves the average rating for a specific product.
    func getAverageRating(for productID: Int) -> Double {
        guard let productRatings = persistenceService.getAllRatings()[productID] else {
            return 0.0
        }
        let ratings = Array(productRatings.values)
        guard !ratings.isEmpty else { return 0.0 }
        return Double(ratings.reduce(0, +)) / Double(ratings.count)
    }
    
    // MARK: - Comments

    /// Retrieves the user's comment for a specific product.
    func getUserComment(for productID: Int) -> String? {
        return persistenceService.getUserComment(for: productID)
    }
    
    /// Saves the user's comment for a specific product.
    func saveUserComment(for productID: Int, comment: String) {
        persistenceService.saveComment(for: productID, comment: comment)
    }
}
