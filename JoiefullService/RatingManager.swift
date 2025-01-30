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
    
    let UserDefaultsManager: PersistenceService
    
    public init(UserDefaultsManager: PersistenceService) {
        self.UserDefaultsManager = UserDefaultsManager
    }
    
    // MARK: - Functions
    
    public func ratings(for product: Product) -> [ProductRating] {
        guard let rating = UserDefaultsManager.getRating(forProductId: String(product.id)) else {
            return []
        }
        return [rating]
    }
    
    public func averageRating(for product: Product) -> Double {
        let ratings = ratings(for: product)
        return ratings.isEmpty ? 0.0 : Double(ratings.reduce(0) { $0 + $1.score }) / Double(ratings.count)
    }
    
    public func addOrUpdaterating(for product: Product, rating: ProductRating) {
        UserDefaultsManager.saveRating(rating, forProductId: String(product.id))
    }
    
}

