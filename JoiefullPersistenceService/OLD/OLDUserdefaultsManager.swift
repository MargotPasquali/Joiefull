//
//  UserDefaultsManager.swift
//  JoiefullPersistence
//
//  Created by Margot Pasquali on 03/01/2025.
//

import Foundation
import JoiefullModels

public final class OLDUserdefaultsManager {
    
    // MARK: - Constants
    private let userDefaults: UserDefaults
    private let likesKey = "likedProducts"
    private let ratingsKey = "productRatings"
    private let commentsKey = "productComments"
    private let userID = "101"
    
    // MARK: - Init
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Likes

    /// Retrieves a list of product IDs that the user has liked.
    public func getLikedProductIDs() -> [Int] {
        let ids = userDefaults.array(forKey: likesKey) as? [Int] ?? []
        print("💾 [UserDefaults] Got liked IDs: \(ids)")
        return ids
    }
    
    /// Toggles the like state for a specific product by ID.
    public func toggleLike(productID: Int) {
        print("💾 [UserDefaults] Toggling like for product \(productID)")
        var likedIDs = getLikedProductIDs()
        print("💾 [UserDefaults] Before toggle: \(likedIDs)")
        if likedIDs.contains(productID) {
            likedIDs.removeAll { $0 == productID }
        } else {
            likedIDs.append(productID)
        }
        print("💾 [UserDefaults] After toggle: \(likedIDs)")
        userDefaults.set(likedIDs, forKey: likesKey)
    }
    
    /// Checks if a product is liked by the user.
    public func isProductLiked(productID: Int) -> Bool {
        return getLikedProductIDs().contains(productID)
    }
    
    // MARK: - Ratings

    /// Retrieves the user's rating for a specific product by ID.
    public func getUserRating(for productID: Int) -> Int? {
        getAllRatings()[productID]?[userID]
    }
    
    /// Saves the user's rating for a specific product by ID.
    public func saveRating(for productID: Int, rating: Int) {
        guard (1...5).contains(rating) else { return }
        var allRatings = getAllRatings()
        allRatings[productID, default: [:]][userID] = rating
        saveData(allRatings, forKey: ratingsKey)
    }
    
    // MARK: - Comments

    /// Retrieves the user's comment for a specific product by ID.
    public func getUserComment(for productID: Int) -> String? {
        getAllComments()[productID]?[userID]
    }
    
    /// Saves the user's comment for a specific product by ID.
    public func saveComment(for productID: Int, comment: String) {
        var allComments = getAllComments()
        allComments[productID, default: [:]][userID] = comment
        saveData(allComments, forKey: commentsKey)
    }
    
    // MARK: - Helpers

    /// Retrieves all product ratings for all users.
    public func getAllRatings() -> [Int: [String: Int]] {
        fetchData(forKey: ratingsKey, defaultValue: [:])
    }
    
    /// Retrieves all product comments for all users.
    private func getAllComments() -> [Int: [String: String]] {
        fetchData(forKey: commentsKey, defaultValue: [:])
    }
    
    /// Fetches and decodes data from UserDefaults for a given key.
    private func fetchData<T: Decodable>(forKey key: String, defaultValue: T) -> T {
        guard let data = userDefaults.data(forKey: key) else { return defaultValue }
        return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
    }
    
    /// Encodes and saves data to UserDefaults for a given key.
    private func saveData<T: Encodable>(_ data: T, forKey key: String) {
        let encodedData = try? JSONEncoder().encode(data)
        userDefaults.set(encodedData, forKey: key)
    }
}
