//
//  Service.swift
//  JoiefullService
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation
import JoiefullModels

// MARK: - Service Protocol
public protocol ProductService {
    var networkManager: NetworkManagerProtocol { get }
    func fetchClothesData() async throws -> [Product]
    func decodeClothes(from jsonData: Data) -> [ProductDTO]?
}

// MARK: - ServiceError Enum
public enum ServiceError: Error {
    case invalidCredentials
    case invalidResponse
    case unauthorized
    case missingToken
    case serverError
    case networkError(Error)
    case decodingError(DecodingError)
    case unknown
}

// MARK: - RemoteService Class
public final class RemoteProductService: ProductService {

    // MARK: - Properties
    public let networkManager: NetworkManagerProtocol

    // MARK: - Initializer

    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    // MARK: - Fetch Clothes Data
    public func fetchClothesData() async throws -> [Product] {
        guard let url = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json") else {
            throw ServiceError.invalidResponse
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await networkManager.data(for: request)
            
            // Décodage en ProductDTO
            guard let clothesDTOList = decodeClothes(from: data) else {
                throw ServiceError.decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid data format")))
            }
            
            // Conversion en Product
            let clothesList = clothesDTOList.map { $0.toDomainModel() }
            return clothesList
        } catch {
            throw error
        }
    }


    // MARK: - Decode Clothes
    public func decodeClothes(from jsonData: Data) -> [ProductDTO]? {
        let decoder = JSONDecoder()
        do {
            let clothesList = try decoder.decode([ProductDTO].self, from: jsonData)
            return clothesList
        } catch {
            print("Erreur de décodage : \(error)")
            return nil
        }
    }
}
