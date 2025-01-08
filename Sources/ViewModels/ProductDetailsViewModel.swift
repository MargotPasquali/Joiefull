//
//  ProductDetailsViewModel.swift
//  Joiefull
//
//  Created by Margot Pasquali on 04/01/2025.
//

import Foundation
import JoiefullModels
import JoiefullPersistenceService

final class ProductDetailsViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var currentRating: Int = 0
    @Published var averageRating: Double = 0.0
    @Published var comment: String = ""
    
    // MARK: - Constants
    private let productID: Int
    private let persistenceService: UserDefaultsManager
    
    // MARK: - Initializer
    init(productID: Int, persistenceService: UserDefaultsManager) {
        self.productID = productID
        self.persistenceService = persistenceService
        self.currentRating = persistenceService.getRating(for: productID) ?? 0
        self.averageRating = persistenceService.getAverageRating(for: productID)
        self.comment = persistenceService.getComment(for: productID) ?? ""
        
    }
    
    // MARK: - Methods
    func updateRatingAndComment(rating: Int, comment: String) {
        currentRating = rating
        self.comment = comment
        persistenceService.addOrUpdateRating(for: productID, rating: rating)
        persistenceService.addOrUpdateComment(for: productID, comment: comment)
        averageRating = persistenceService.getAverageRating(for: productID)
        print("Debug: Updated rating and comment for product \(productID). Rating: \(rating), Comment: \(comment), Average: \(averageRating).")
    }
}
