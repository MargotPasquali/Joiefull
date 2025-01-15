//
//  ProductListViewModel.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation
import JoiefullModels
import JoiefullPersistenceService
import JoiefullService

@MainActor
final class ProductListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var products: [Product]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private let persistenceService: UserDefaultsManager

    // MARK: - Initializer
    /// Initializes the view model with a list of products and a persistence service.
    init(products: [Product] = [], persistenceService: UserDefaultsManager) {
        self.products = products
        self.persistenceService = persistenceService
    }

    // MARK: - Fetch Products
    /// Fetches the product list from the remote API.
    func fetchProductList() async {
        isLoading = true
        do {
            let remoteService = RemoteProductService(networkManager: NetworkManager())
            let fetchedProducts = try await remoteService.fetchClothesData()
            products = fetchedProducts
            isLoading = false
        } catch let serviceError as ServiceError {
            handleServiceError(serviceError)
            isLoading = false
        } catch {
            errorMessage = "Unable to load products: \(error.localizedDescription)"
            isLoading = false
        }
    }

    // MARK: - Handle Errors
    /// Handles errors specific to the service layer.
    private func handleServiceError(_ serviceError: ServiceError) {
        switch serviceError {
        case .unauthorized:
            errorMessage = "Unauthorized access. Please check your credentials."
        case .networkError(let error):
            errorMessage = "Network error: \(error.localizedDescription)"
        case .serverError:
            errorMessage = "Server error. Please try again later."
        case .decodingError(let decodingError):
            errorMessage = "Decoding error: \(decodingError.localizedDescription)"
        default:
            errorMessage = "An unexpected error occurred."
        }
    }

    // MARK: - Update Specific Product
    /// Updates a specific product in the list.
    func updateProduct(_ updatedProduct: Product) {
        if let index = products.firstIndex(where: { $0.id == updatedProduct.id }) {
            products[index] = updatedProduct
            objectWillChange.send() // Force a UI update
            print("[DEBUG] updateProduct: Product \(updatedProduct.id) updated.")
        }
    }

    // MARK: - Update Average Ratings
    /// Updates the average ratings for all products.
    func updateAverageRatings() {
        for index in products.indices {
            let productID = products[index].id
            let averageRating = persistenceService.getAverageRating(for: productID)
            
            if averageRating > 0 {
                products[index].ratings = products[index].ratings.filter { $0.userID != "101" }
                products[index].ratings.append(
                    Rating(userID: "101", score: Int(averageRating), comment: nil)
                )
                print("[DEBUG] updateAverageRatings: Updated ratings for product \(productID).")
            }
            objectWillChange.send()
        }
    }

    // MARK: - Like Management
    /// Checks if a product is liked by the user.
    func isLiked(product: Product) -> Bool {
        return persistenceService.isProductLiked(productID: product.id)
    }

    /// Toggles the like state for a product.
    func toggleLike(for product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            if isLiked(product: product) {
                persistenceService.unlikeProduct(productID: product.id)
                products[index].likes -= 1
            } else {
                persistenceService.likeProduct(productID: product.id)
                products[index].likes += 1
            }
            print("[DEBUG] toggleLike: Product \(product.id) updated likes to \(products[index].likes).")
        }
    }
}

// MARK: - Helper Properties
extension ProductListViewModel {
    /// Groups products by category.
    var categories: [Product.Category: [Product]] {
        Dictionary(grouping: products, by: { $0.category })
    }
}
