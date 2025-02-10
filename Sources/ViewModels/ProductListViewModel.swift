//
//  ProductListViewModel.swift
//  Joiefull
//
//  Created by Margot Pasquali on 23/01/2025.
//
import Foundation
import JoiefullModels
import JoiefullService

@MainActor
final class ProductListViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var products: [Product] = []
    @Published var productRatings: [Int: Double] = [:]
    @Published var productLikes: [Int: Int] = [:]


    // MARK: - Constants
    private let service: RemoteProductService
    let likeManager: LikeManager
    let ratingManager: RatingManager
    
    // MARK: - Init
    init(
        products: [Product] = [],
        service: RemoteProductService = RemoteProductService(),
        likeManager: LikeManager = LikeManager(),
        ratingManager: RatingManager = RatingManager()
    ) {
        self.products = products
        self.service = service
        self.likeManager = likeManager
        self.ratingManager = ratingManager
        updateLikes()
    }
    
    // MARK: - Functions
    func fetchProducts() async {
        isLoading = true
        do {
            products = try await service.fetchClothesData()
            // Fetch changes with likes and ratings
            refreshData()
        } catch {
            errorMessage = "Failed to fetch products: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func toggleLike(for product: Product) {
        let result = likeManager.toggleLike(for: product)
        productLikes[product.id] = result.updatedLikes
        refreshData()
    }
    
    func isLiked(_ product: Product) -> Bool {
        let liked = likeManager.isLiked(for: product)
        return liked
    }
    
    func averageRating(for product: Product) -> Double {
        let avgRating = ratingManager.averageRating(for: product)
        return avgRating
    }
    
    func updateAverageRatings() {
        productRatings = products.reduce(into: [:]) { $0[$1.id] = ratingManager.averageRating(for: $1) }
    }
    
    func updateLikes() {
        for product in products {
            productLikes[product.id] = likeManager.getUpdatedLikes(for: product)
        }
    }
    
    func refreshData() {
        updateLikes()
        updateAverageRatings()
    }
}
