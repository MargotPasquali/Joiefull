//
//  ProductDetailsViewModel.swift
//  Joiefull
//
//  Created by Margot Pasquali on 04/01/2025.
//

import Foundation
import JoiefullModels
import JoiefullPersistenceService

@MainActor
final class ProductDetailsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var product: Product
    @Published var currentRating: Int = 0
    @Published var comment: String = ""
    
    // MARK: - Private Properties
    private let persistenceService: UserDefaultsManager
    
    // MARK: - Initializer
    /// Initializes the view model with a product and a persistence service.
    init(product: Product, persistenceService: UserDefaultsManager) {
        self.product = product
        self.persistenceService = persistenceService
        self.currentRating = persistenceService.getRating(for: product.id) ?? 0
        self.comment = persistenceService.getComment(for: product.id) ?? ""
    }
    
    // MARK: - Data Loading
    /// Loads persisted rating and comment for the current product.
    func loadPersistedData() async {
        self.currentRating = persistenceService.getRating(for: product.id) ?? 0
        self.comment = persistenceService.getComment(for: product.id) ?? ""
    }
    
    // MARK: - Update Data
    /// Updates the user's rating and comment for the current product.
    func updateRatingAndComment(rating: Int, comment: String) {
        currentRating = rating
        self.comment = comment
        
        // Update persistence with the new rating and comment
        persistenceService.addOrUpdateRating(for: product.id, rating: rating)
        persistenceService.addOrUpdateComment(for: product.id, comment: comment)
        
        // Update the product's ratings list
        if let index = product.ratings.firstIndex(where: { $0.userID == "101" }) {
            product.ratings[index] = Rating(userID: "101", score: rating, comment: comment)
        } else {
            product.ratings.append(Rating(userID: "101", score: rating, comment: comment))
        }
        
        // Recalculate and update the average rating
        let averageRating = persistenceService.getAverageRating(for: product.id)
        product.ratings = product.ratings.filter { $0.userID != "101" }
        product.ratings.append(Rating(userID: "101", score: Int(averageRating), comment: nil))
    }
}
