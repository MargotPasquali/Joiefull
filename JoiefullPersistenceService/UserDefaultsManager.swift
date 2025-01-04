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
}
