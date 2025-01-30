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

    // MARK: - Constants
    let service: RemoteProductService
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
    }
    
    // MARK: - Functions
    func fetchProducts() async {
        isLoading = true
        do {
            products = try await service.fetchClothesData()
        } catch {
            errorMessage = "Failed to fetch products: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func toggleLike(for product: Product) {
        _ = likeManager.toggleLike(for: product)

        objectWillChange.send()
    }
    
    func isLiked(_ product: Product) -> Bool {
        likeManager.isLiked(for: product)
    }
    
    func averageRating(for product: Product) -> Double {
        ratingManager.averageRating(for: product)
    }
    
    func updateAverageRatings() {
//       products = products.map { product in
//           let avgRating = ratingManager.averageRating(for: product)
//           return Product(
//               id: product.id,
//               picture: product.picture,
//               name: product.name,
//               category: product.category,
//               likes: product.likes,
//               price: product.price,
//               originalPrice: product.originalPrice
//           )
//       }
    }
}
