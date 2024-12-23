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

    // MARK: - ServiceError Enum
    public enum ServiceError: Error {
        case invalidCredentials
        case invalidResponse
        case unauthorized
        case missingToken
        case networkError(Error)
        case decodingError(DecodingError)
        case unknown
    }

    // MARK: - Properties
    @Published var products: [Clothes] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var Service: Service

    // MARK: - Computed Properties
    var categories: [Clothes.Category: [Clothes]] {
        Dictionary(grouping: products, by: { $0.category })
    }

    // MARK: - Initializer
    init(Service: Service = RemoteService()) {
        self.Service = Service
    }

    // MARK: - Public Methods
    @MainActor
    func fetchProductList() async {
        print("Fetching product list...")
        
        isLoading = true
        
        do {
            let productList = try await Service.fetchClothesData()
            products = productList
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
