//
//  ProductListViewModel.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation
import JoiefullModels
import JoiefullService
import JoiefullPersistenceService

// MARK: - ProductListViewModel
final class ProductListViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var products = [Product]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let productService: ProductService
    private let persistenceService: PersistenceService
    
    
    // MARK: - Computed Properties
    var categories: [Product.Category: [Product]] {
        Dictionary(grouping: products, by: { $0.category })
    }
    
    // MARK: - Initializer
    init(productService: ProductService, products: [Product] = [], persistenceService: PersistenceService) {
        self.productService = productService
        self.products = products
        self.persistenceService = persistenceService
    }
    
    // MARK: - Methods
    @MainActor
    func fetchProductList() async {
        print("Fetching product list...")
        
        isLoading = true
        
        do {
            products = try await productService.fetchClothesData()
            isLoading = false
        } catch {
            // Gestion des erreurs
            if let serviceError = error as? ServiceError {
                errorMessage = serviceError.localizedDescription
            } else {
                errorMessage = "An unknown error occurred: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
        func toggleLike(for product: Product) {
            if persistenceService.isProductLiked(productID: product.id) {
                persistenceService.unlikeProduct(productID: product.id)
            } else {
                persistenceService.likeProduct(productID: product.id)
            }
            // local product update
            if let index = products.firstIndex(where: { $0.id == product.id }) {
                var updatedProduct = products[index]
                updatedProduct.likes += persistenceService.isProductLiked(productID: product.id) ? 1 : -1
                products[index] = updatedProduct
            }
        }
        
        func isLiked(product: Product) -> Bool {
            persistenceService.isProductLiked(productID: product.id)
        }
}
