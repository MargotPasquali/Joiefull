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
    @Published private(set) var product: Product
    @Published var userRating: Int = 0
    @Published var userComment: String = ""
    
    // MARK: - Constants
    let ratingManager: RatingManager
    let likeManager: LikeManager
    
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
        let avgRating = ratingManager.averageRating(for: product)
        let isLiked = likeManager.isLiked(for: product)
        
        product = Product(
            id: product.id,
            picture: product.picture,
            name: product.name,
            category: product.category,
            likes: product.likes,
            price: product.price,
            originalPrice: product.originalPrice
        )
    }
    
    func toggleLike() {
        let result = likeManager.toggleLike(for: product)
        product = Product(
            id: product.id,
            picture: product.picture,
            name: product.name,
            category: product.category,
            likes: result.updatedLikes,
            price: product.price,
            originalPrice: product.originalPrice
        )
    }
    
    func isLiked(_ product: Product) -> Bool {
        likeManager.isLiked(for: product)
    }
    
    func averageRating(for product: Product) -> Double {
        ratingManager.averageRating(for: product)
    }
}
