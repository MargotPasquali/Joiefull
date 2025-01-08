//
//  UserDefaultsManager.swift
//  JoiefullPersistence
//
//  Created by Margot Pasquali on 03/01/2025.
//

import Foundation

public final class UserDefaultsManager {
    
    // MARK: - Constants
    
    private let userDefaults: UserDefaults
    private let likesKey = "likedProducts"
    private let ratingsKey = "productRatings"
    
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Like Methods
    public func getLikedProductIDs() -> [Int] {
        userDefaults.array(forKey: likesKey) as? [Int] ?? []
    }
    
    public func likeProduct(productID: Int) {
        var likedProductIDs = getLikedProductIDs()
        if !likedProductIDs.contains(productID) {
            likedProductIDs.append(productID)
            userDefaults.set(likedProductIDs, forKey: likesKey)
        }
    }
    
    public func unlikeProduct(productID: Int) {
        var likedProductIDs = getLikedProductIDs()
        if let index = likedProductIDs.firstIndex(of: productID) {
            likedProductIDs.remove(at: index)
            userDefaults.set(likedProductIDs, forKey: likesKey)
        }
    }
    
    public func isProductLiked(productID: Int) -> Bool {
        getLikedProductIDs().contains(productID)
    }
    
    // MARK: - Rating Methods
    
    /// Add or update a rating for product by static userID (101).
    public func addOrUpdateRating(for productID: Int, rating: Int) {
        var allRatings = getAllRatings()
        var productRatings = allRatings[productID] ?? [:]
        productRatings["101"] = rating // Fixed userID
        allRatings[productID] = productRatings
        
        // Serialize to JSON
        do {
            let data = try JSONEncoder().encode(allRatings)
            userDefaults.set(data, forKey: ratingsKey)
            print("Debug: Successfully saved ratings.")
        } catch {
            print("Error: Failed to save ratings. \(error)")
        }
    }
    
    /// Get a rating for a specific product by userID 101.
    public func getRating(for productID: Int) -> Int? {
        let allRatings = getAllRatings()
        let productRatings = allRatings[productID] ?? [:]
        return productRatings["101"]
    }
    
    /// Get the average rating for a product.
    public func getAverageRating(for productID: Int) -> Double {
        let allRatings = getAllRatings()
        guard let productRatings = allRatings[productID] else { return 0.0 }
        let total = productRatings.values.reduce(0, +)
        let count = productRatings.count
        return count > 0 ? Double(total) / Double(count) : 0.0
    }
    
    /// Retrieve all ratings.
    private func getAllRatings() -> [Int: [String: Int]] {
        guard let data = userDefaults.data(forKey: ratingsKey) else {
            print("Debug: No ratings data found.")
            return [:]
        }
        do {
            // Attempt to decode the new format
            let ratings = try JSONDecoder().decode([Int: [String: Int]].self, from: data)
            print("Debug: Retrieved ratings: \(ratings)")
            return ratings
        } catch {
            print("Error: Failed to decode ratings. \(error)")
            
            // Attempt recovery for legacy format (if stored as a dictionary)
            if let legacyRatings = userDefaults.dictionary(forKey: ratingsKey) as? [Int: [String: Any]] {
                var convertedRatings: [Int: [String: Int]] = [:]
                for (productID, userRatings) in legacyRatings {
                    let filteredRatings = userRatings.compactMapValues { $0 as? Int }
                    convertedRatings[productID] = filteredRatings
                }
                
                print("Debug: Converted legacy ratings: \(convertedRatings)")
                
                // Save converted data in the new format
                do {
                    let newData = try JSONEncoder().encode(convertedRatings)
                    userDefaults.set(newData, forKey: ratingsKey)
                    print("Debug: Saved converted ratings.")
                } catch {
                    print("Error: Failed to save converted ratings. \(error)")
                }
                
                return convertedRatings
            }
            
            return [:]
        }
    }
    
    public func addOrUpdateComment(for productID: Int, comment: String) {
        var allComments = getAllComments()
        var productComments = allComments[productID] ?? [:]
        productComments["101"] = comment // Fixed user ID
        allComments[productID] = productComments
        
        // Serialize to JSON
        do {
            let data = try JSONEncoder().encode(allComments)
            userDefaults.set(data, forKey: "productComments")
            print("Debug: Successfully saved comments.")
        } catch {
            print("Error: Failed to save comments. \(error)")
        }
    }

    public func getComment(for productID: Int) -> String? {
        let allComments = getAllComments()
        let productComments = allComments[productID] ?? [:]
        return productComments["101"]
    }

    private func getAllComments() -> [Int: [String: String]] {
        guard let data = userDefaults.data(forKey: "productComments") else {
            print("Debug: No comments data found.")
            return [:]
        }
        do {
            return try JSONDecoder().decode([Int: [String: String]].self, from: data)
        } catch {
            print("Error: Failed to decode comments. \(error)")
            return [:]
        }
    }
}
