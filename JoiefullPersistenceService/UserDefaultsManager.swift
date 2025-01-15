//
//  UserDefaultsManager.swift
//  JoiefullPersistence
//
//  Created by Margot Pasquali on 03/01/2025.
//

import Foundation
import JoiefullModels

public final class UserDefaultsManager {
    
    // MARK: - Constants
    private let userDefaults: UserDefaults
    private let likesKey = "likedProducts"
    private let ratingsKey = "productRatings"
    private let commentsKey = "productComments"
    private let userID = "101"
    
    // MARK: - Initializer
    /// Initializes `UserDefaultsManager` with a `UserDefaults` instance.
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Like Management
    /// Fetches the list of liked product IDs.
    public func getLikedProductIDs() -> [Int] {
        userDefaults.array(forKey: likesKey) as? [Int] ?? []
    }
    
    /// Adds a product ID to the liked products list.
    public func likeProduct(productID: Int) {
        var likedProductIDs = getLikedProductIDs()
        if !likedProductIDs.contains(productID) {
            likedProductIDs.append(productID)
            userDefaults.set(likedProductIDs, forKey: likesKey)
        }
    }
    
    /// Removes a product ID from the liked products list.
    public func unlikeProduct(productID: Int) {
        var likedProductIDs = getLikedProductIDs()
        likedProductIDs.removeAll { $0 == productID }
        userDefaults.set(likedProductIDs, forKey: likesKey)
    }
    
    /// Checks if a product is liked.
    public func isProductLiked(productID: Int) -> Bool {
        getLikedProductIDs().contains(productID)
    }
    
    // MARK: - Rating Management
    /// Adds or updates a rating for a specific product.
    public func addOrUpdateRating(for productID: Int, rating: Int) {
        guard (1...5).contains(rating) else { return } // Ensure rating is valid
        
        var allRatings = getAllRatings()
        var productRatings = allRatings[productID] ?? [:]
        productRatings[userID] = rating
        allRatings[productID] = productRatings

        saveData(allRatings, forKey: ratingsKey)
    }
    
    /// Fetches the current user's rating for a specific product.
    public func getRating(for productID: Int) -> Int? {
        let allRatings = getAllRatings()
        return allRatings[productID]?[userID]
    }
    
    /// Calculates the average rating for a specific product.
    public func getAverageRating(for productID: Int) -> Double {
        let allRatings = getAllRatings()
        guard let productRatings = allRatings[productID] else { return 0.0 }
        
        let total = productRatings.values.reduce(0, +)
        return Double(total) / Double(productRatings.count)
    }
    
    // MARK: - Comment Management
    /// Adds or updates a comment for a specific product.
    public func addOrUpdateComment(for productID: Int, comment: String) {
        var allComments = getAllComments()
        var productComments = allComments[productID] ?? [:]
        productComments[userID] = comment
        allComments[productID] = productComments

        saveData(allComments, forKey: commentsKey)
    }
    
    /// Fetches the current user's comment for a specific product.
    public func getComment(for productID: Int) -> String? {
        let allComments = getAllComments()
        return allComments[productID]?[userID]
    }
    
    // MARK: - Private Helper Methods
    /// Retrieves all ratings from persistent storage.
    private func getAllRatings() -> [Int: [String: Int]] {
        fetchData(forKey: ratingsKey, defaultValue: [:])
    }
    
    /// Retrieves all comments from persistent storage.
    private func getAllComments() -> [Int: [String: String]] {
        fetchData(forKey: commentsKey, defaultValue: [:])
    }
    
    /// Fetches data for a specific key or returns a default value.
    private func fetchData<T: Decodable>(forKey key: String, defaultValue: T) -> T {
        guard let data = userDefaults.data(forKey: key) else { return defaultValue }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return defaultValue
        }
    }
    
    /// Saves data for a specific key.
    private func saveData<T: Encodable>(_ data: T, forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            print("Error saving data: \(error)")
        }
    }
}
