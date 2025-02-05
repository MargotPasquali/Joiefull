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
    @Published var currentLikes: Int
    
    // MARK: - Constants
    
    private let ratingManager: RatingManager
    private let likeManager: LikeManager
    
    // MARK: - Init
    
    private let onLikeUpdated: (Int) -> Void
    
    init(product: Product, ratingManager: RatingManager, likeManager: LikeManager, onLikeUpdated: @escaping (Int) -> Void) {
        self.product = product
        self.ratingManager = ratingManager
        self.likeManager = likeManager
        self.onLikeUpdated = onLikeUpdated
        self.currentLikes = likeManager.getUpdatedLikes(for: product)
        self.isLiked = likeManager.isLiked(for: product)
    }
    
    // MARK: - Functions
    
    func saveUserFeedback(score: Int, comment: String) {
        userRating = score
        userComment = comment
        
        let rating = ProductRating(score: score, comment: comment)
        ratingManager.addOrUpdaterating(for: product, rating: rating)
        
    }
    
    func updateLikesAndRatings() {
        // Get ratings
        let ratings = ratingManager.ratings(for: product)
        
        // Average calculation
        if !ratings.isEmpty {
            averageRating = Double(ratings.reduce(0) { $0 + $1.score }) / Double(ratings.count)
        } else {
            averageRating = 0.0
        }
        
        // Properties update
        userRating = ratings.first?.score ?? 0
        userComment = ratings.first?.comment ?? ""
        currentLikes = likeManager.getUpdatedLikes(for: product)
        isLiked = likeManager.isLiked(for: product)
        
    }
    
    func toggleLike() {
        let result = likeManager.toggleLike(for: product)
        isLiked = result.isLiked
        currentLikes = result.updatedLikes
        onLikeUpdated(result.updatedLikes)
    }
    
    func isLiked(_ product: Product) -> Bool {
        let liked = likeManager.isLiked(for: product)
        return liked
    }
    
    func averageRating(for product: Product) -> Double {
        let avgRating = ratingManager.averageRating(for: product)
        return avgRating
    }
}
