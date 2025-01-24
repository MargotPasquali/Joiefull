//
//  ProductViewModel.swift
//  Joiefull
//
//  Created by Margot Pasquali on 22/01/2025.
//
//
//import Foundation
//import JoiefullModels
//import JoiefullPersistenceService
//import JoiefullService
//
//@MainActor
//final class ProductViewModel: ObservableObject {
//    
//    // MARK: - Properties
//    @Published var products: [Product]
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//    @Published var userRating: Int = 0
//    @Published var userComment: String = ""
//    @Published var likedProductIDs: Set<Int>
//    
//    // MARK: - Constants
//    let ratingRepository: RatingRepository
//    
//    // MARK: - Init
//    init(products: [Product] = [], ratingRepository: RatingRepository) {
//        self.products = products
//        self.ratingRepository = ratingRepository
//        self.likedProductIDs = Set(ratingRepository.getLikedProductIDs())
//    }
//    
//    // MARK: - Product List Management
//
//    /// Fetches the list of products from the remote API.
//    func fetchProducts() async {
//        isLoading = true
//        do {
//            let service = RemoteProductService(networkManager: NetworkManager())
//            products = try await service.fetchClothesData()
//        } catch {
//            errorMessage = "Failed to fetch products: \(error.localizedDescription)"
//        }
//        isLoading = false
//    }
//    
//    /// Toggles the like state for a product and updates the like count.
//    func toggleLike(for productID: Int) {
//        if let index = products.firstIndex(where: { $0.id == productID }) {
//            let wasLiked = likedProductIDs.contains(productID)
//            products[index].likes += wasLiked ? -1 : 1
//            if wasLiked {
//                likedProductIDs.remove(productID)
//            } else {
//                likedProductIDs.insert(productID)
//            }
//            objectWillChange.send()
//        }
//        ratingRepository.toggleLike(for: productID)
//    }
//
//    /// Checks if a product is liked by the user.
//    func isLiked(product: Product) -> Bool {
//        ratingRepository.isProductLiked(productID: product.id)
//    }
//    
//    // MARK: - Product Ratings Management
//
//    /// Loads the user's rating and comment for a specific product.
//    func loadProductData(for productID: Int) async {
//        userRating = ratingRepository.getUserRating(for: productID) ?? 0
//        userComment = ratingRepository.getUserComment(for: productID) ?? ""
//    }
//    
//    /// Saves the user's feedback (rating and comment) for a specific product.
//    func saveUserFeedback(for productID: Int, rating: Int, comment: String) {
//        userRating = rating
//        userComment = comment
//        ratingRepository.saveUserRating(for: productID, rating: rating)
//        ratingRepository.saveUserComment(for: productID, comment: comment)
//
//        if let index = products.firstIndex(where: { $0.id == productID }) {
//            products[index].averageRating = ratingRepository.getAverageRating(for: productID)
//            objectWillChange.send()
//        }
//    }
//    
//    /// Updates the average ratings for all products in the list.
//    func updateAverageRatings() {
//        for index in products.indices {
//            let productID = products[index].id
//            products[index].averageRating = ratingRepository.getAverageRating(for: productID)
//        }
//    }
//}
