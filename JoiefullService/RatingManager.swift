//
//  RatingManager.swift
//  JoiefullService
//
//  Created by Margot Pasquali on 23/01/2025.
//
import Foundation
import JoiefullModels
import JoiefullPersistenceService

public final class RatingManager {
    
    // MARK: - Constants
    
    let userDefaultsManager: PersistenceService
    
    public init(userDefaultsManager: PersistenceService = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    // MARK: - Functions
    
    public func ratings(for product: Product) -> [ProductRating] {
        guard let rating = userDefaultsManager.getRating(forProductId: String(product.id)) else {
            return []
        }
        return [rating]
    }
    
    public func averageRating(for product: Product) -> Double {
        let ratings = ratings(for: product)
        if ratings.isEmpty {
            return 0.0
        }
        
        let avgRating = Double(ratings.reduce(0) { $0 + $1.score }) / Double(ratings.count)
        return avgRating
    }
    
    public func addOrUpdaterating(for product: Product, rating: ProductRating) {
        userDefaultsManager.saveRating(rating, forProductId: String(product.id))
    }
}
