//
//  Service.swift
//  JoiefullService
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation
import JoiefullModels

// MARK: - Service Protocol
public protocol Service {
    var networkManager: NetworkManagerProtocol { get }
    func fetchClothesData() async throws -> [Clothes]
    func decodeClothes(from jsonData: Data) -> [Clothes]?
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
public final class RemoteService: Service {

    // MARK: - Properties
    public let networkManager: NetworkManagerProtocol

    // MARK: - Initializer
    public init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - Fetch Clothes Data
    public func fetchClothesData() async throws -> [Clothes] {
        guard let url = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json") else {
            throw ServiceError.invalidResponse
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let clothesList = decodeClothes(from: data) else {
                throw ServiceError.decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid data format")))
            }
            return clothesList
        } catch {
            throw ServiceError.networkError(error)
        }
    }

    // MARK: - Decode Clothes
    public func decodeClothes(from jsonData: Data) -> [Clothes]? {
        let decoder = JSONDecoder()
        do {
            let clothesList = try decoder.decode([Clothes].self, from: jsonData)
            return clothesList
        } catch {
            print("Erreur de décodage : \(error)")
            return nil
        }
    }
}
