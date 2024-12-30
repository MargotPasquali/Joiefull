//
//  ProductListViewModel.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation
import JoiefullModels
import JoiefullService

// MARK: - ProductListViewModel
final class ProductListViewModel: ObservableObject {

    // MARK: - Properties
    @Published var products = [Product]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var productService: ProductService

    // MARK: - Computed Properties
    var categories: [Product.Category: [Product]] {
        Dictionary(grouping: products, by: { $0.category })
    }

    // MARK: - Initializer
    init(productService: ProductService, products: [Product] = []) {
            self.productService = productService
            self.products = products
        }

    // MARK: - Public Methods
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
}
