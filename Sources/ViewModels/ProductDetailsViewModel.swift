//
//  ProductDetailsViewModel.swift
//  Joiefull
//
//  Created by Margot Pasquali on 23/01/2025.
//

import Foundation
import JoiefullModels
import JoiefullPersistenceService
import JoiefullService

@MainActor
final class ProductDetailsViewModel: ObservableObject {
    
    // MARK: - Properties

    let product: Product

    @Published var isLiked = false
    @Published var averageRating = 0.0
    @Published var userRating = 0
    @Published var userComment = ""
    
    // MARK: - Constants

    private let ratingManager: RatingManager
    private let likeManager: LikeManager

    // MARK: - Init
    
    init(product: Product, ratingManager: RatingManager, likeManager: LikeManager) {
        self.product = product
        self.ratingManager = ratingManager
        self.likeManager = likeManager
    }
    
    // MARK: - Functions
    
    func saveUserFeedback(score: Int, comment: String) {
        print("📝 Saving feedback - Score: \(score), Comment: \(comment)")
        userRating = score
        userComment = comment
        let rating = ProductRating(score: score, comment: comment)
        print("🔄 Created ProductRating: score=\(rating.score), comment=\(rating.comment)")
        ratingManager.addOrUpdaterating(for: product, rating: rating)
    }
    
    func updateLikesAndRatings() {
        averageRating = ratingManager.averageRating(for: product)

        if let rating = ratingManager.ratings(for: product).first {
            userRating = rating.score
            userComment = rating.comment
        }

        isLiked = likeManager.isLiked(for: product)
    }
    
    func toggleLike() {
        isLiked = likeManager.toggleLike(for: product).isLiked
    }
    
    func isLiked(_ product: Product) -> Bool {
        likeManager.isLiked(for: product)
    }
    
    func averageRating(for product: Product) -> Double {
        ratingManager.averageRating(for: product)
    }
}
